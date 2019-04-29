#include <iostream>
#include <list>
#include <cmath>
#include <cstdio>
#include <vector>
#include <fstream>
#include <gsl/gsl_interp.h>
#include <algorithm>
#include "polynomials.h"

class Node {
private:
    double x, y;
public:
    Node(double x, double y) : x(x), y(y) {}

    double getX() const {
        return x;
    }

    double getY() const {
        return y;
    }

    bool operator<(const Node &node) { return x < node.getX(); }
};

double **_F;
bool **isSet;

double F(int a, int b, std::vector<Node> nodes) {
    if (!isSet[a][b]) {
        if (a == b) {
            _F[a][b] = nodes[a].getY();
        } else {
            _F[a][b] = (F(a + 1, b, nodes) - F(a, b - 1, nodes)) / (nodes[b].getX() - nodes[a].getX());
        }
        isSet[a][b] = true;
    }
    return _F[a][b];
}

Poly newtonInterpolation(std::vector<Node> nodes) {
    Poly W({Term{F(0, 0, nodes), 0}});
    for (int i = 1; i < nodes.size(); i++) {
        Poly C({Term(F(0, i, nodes), 0)});
        for (int j = 0; j < i; j++) {
            C = C * Poly({Term(1, 1), Term(-nodes[j].getX(), 0)});
        }
        W = W + C;
    }
    return W;
}

Poly lagrangeInterpolation(std::vector<Node> nodes) {
    Poly L[nodes.size()];
    Poly W({Term(0, 0)});
    for (int i = 0; i < nodes.size(); i++) {
        Poly num({Term(1, 0)});
        double denom = 1.0;
        for (int k = 0; k < nodes.size(); k++) {
            if (k != i) {
                Poly b({Term(1, 1), Term(-nodes[k].getX(), 0)});
                num = num * b;
                denom *= nodes[i].getX() - nodes[k].getX();
            }
        }
        L[i] = num / denom;
    }
    W = L[0] * nodes[0].getY();
    for (int i = 1; i < nodes.size(); i++) {
        W = W + L[i] * nodes[i].getY();
    }
    return W;
}

int randNumberOfNodes() {
    return rand() % 7 + 3;
}

void initF(int numberOfNodes) {
    _F = new double *[numberOfNodes + 1];
    isSet = new bool *[numberOfNodes + 1];
    for (int i = 0; i < numberOfNodes + 1; i++) {
        _F[i] = new double[numberOfNodes + 1];
        isSet[i] = new bool[numberOfNodes + 1];
        for (int j = 0; j < numberOfNodes + 1; j++) {
            isSet[i][j] = false;
        }
    }
}

void clearF(int numberOfNodes) {
    for (int i = 0; i < numberOfNodes + 1; i++) {
        delete _F[i];
        delete isSet[i];
    }
    delete _F;
    delete isSet;
}

void getClock(timespec *spec) {
    if (clock_gettime(CLOCK_REALTIME, spec) == -1) {
        printf("Problem with clock\n");
        exit(1);
    }
}

std::vector<Node> generateNodes(int numberOfNodes, double &minX, double &maxX) {
    std::vector<Node> nodes;
    for (int i = 0; i < numberOfNodes; i++) {
        nodes.push_back(Node(10 - rand() % 1000 * 1.0 / 50.0, rand() % 1000 * 1.0 / 100.0));
    }
    std::sort(nodes.begin(), nodes.end());

    std::fstream file;
    file.open("points.csv", std::ios_base::out | std::ios::trunc);
    file << "x,y\n";
    for (int i = 0; i < numberOfNodes; i++) {
        if (minX > nodes[i].getX())minX = nodes[i].getX();
        if (maxX < nodes[i].getX())maxX = nodes[i].getX();
        file << nodes[i].getX() << "," << nodes[i].getY() << "\n";
    }
    file.close();
    return nodes;
}

void exportPolynomial(std::string name, Poly poly, double minX, double maxX) {
    std::fstream file;
    std::cout << name << ": " << poly.toString() << "\n";
    file.open(name + ".csv", std::ios_base::out | std::ios::trunc);
    file << "x,y\n";
    for (double x = minX; x <= maxX; x += 0.1) {
        file << x << "," << poly.calculate(x) << "\n";
    }
    file.close();
}

double *calcInterpolationForRandomValues() {
    double *runTimes = new double[3];
    timespec start, stop;
    int numberOfNodes = randNumberOfNodes();

    double minX = 10000, maxX = -10000;
    std::vector<Node> nodes = generateNodes(numberOfNodes, minX, maxX);

    initF(numberOfNodes);
    getClock(&start);
    Poly newtonRes = newtonInterpolation(nodes);
    getClock(&stop);
    clearF(numberOfNodes);

    runTimes[0] = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;
    exportPolynomial("Newton", newtonRes, minX, maxX);

    getClock(&start);
    Poly lagrangeRes = lagrangeInterpolation(nodes);
    getClock(&stop);

    runTimes[1] = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;
    exportPolynomial("Lagrange", lagrangeRes, minX, maxX);

    double xArr[nodes.size()], yArr[nodes.size()];
    for (int i = 0; i < nodes.size(); i++) {
        xArr[i] = nodes[i].getX();
        yArr[i] = nodes[i].getY();
    }

    gsl_interp *interp = gsl_interp_alloc(gsl_interp_polynomial, nodes.size());
    getClock(&start);
    gsl_interp_init(interp, xArr, yArr, nodes.size());
    getClock(&stop);
    runTimes[2] = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;

    gsl_interp_accel *accel = gsl_interp_accel_alloc();

    std::fstream file;
    file.open("gsl.csv", std::ios_base::out | std::ios::trunc);
    file << "x,y\n";
    for (double x = minX; x <= maxX; x += 0.1) {
        file << x << "," << gsl_interp_eval(interp, xArr, yArr, x, accel) << "\n";
    }
    file.close();

    gsl_interp_accel_free(accel);
    gsl_interp_free(interp);

    return runTimes;
}

int main() {
    srand(time(NULL));
    std::fstream file;
    file.open("times.csv", std::ios_base::out | std::ios::trunc);
    file << "newton,lagrange,gsl\n";
    for (int i = 0; i < 100; i++) {
        double *times = calcInterpolationForRandomValues();
        file << times[0] << "," << times[1] << "," << times[2] << "\n";
        delete times;
    }
    file.close();
    return 0;
}
