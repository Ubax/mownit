//
// Created by ubax on 13.04.19.
//

#ifndef ZAD2_POLYNOMIALS_H
#define ZAD2_POLYNOMIALS_H

class Term {
private:
    double coefficient;
    int exponent;
public:
    Term(double coefficient, int exponent) : coefficient(coefficient), exponent(exponent) {}

    Term() { Term(0, 0); }

    Term add(double coefficient) {
        return Term(this->coefficient + coefficient, this->exponent);
    }

    double getCoefficient() const {
        return coefficient;
    }

    int getExponent() const {
        return exponent;
    }

    double calculate(double x) {
        return coefficient * pow(x, exponent);
    }

    std::string toString() {
        std::string ret;
        if (coefficient > 0)ret += "+";
        ret += std::to_string(coefficient);
        if (exponent != 0) {
            ret += "x^";
            ret += std::to_string(exponent);
        }
        return ret;
    }
};

class Poly {
private:
    std::list<Term> terms;
    int degree;
public:
    Poly() { degree = -1; }

    Poly(const std::list<Term> &terms) : terms(terms) {
        degree = 0;
        for (auto term: terms) {
            if (term.getExponent() > degree)degree = term.getExponent();
        }
    }

    Poly operator*(Poly const &obj) {
        Term terms[degree + obj.degree + 1];
        for (int i = 0; i < degree + obj.degree + 1; i++) {
            terms[i] = Term(0.0, i);
        }

        for (auto objTerm: obj.terms) {
            for (auto term: this->terms) {
                int exp = objTerm.getExponent() + term.getExponent();
                double value = objTerm.getCoefficient() * term.getCoefficient();
                terms[exp] = terms[exp].add(value);
            }
        }

        std::list<Term> termsList;
        for (int i = degree + obj.degree; i >= 0; i--) {
            if (terms[i].getCoefficient() != 0.0)termsList.push_back(terms[i]);
        }

        return Poly(termsList);
    }

    Poly operator+(Poly const &obj) {
        int degree = (this->degree > obj.degree ? this->degree : obj.degree);
        Term terms[degree + 1];
        for (int i = 0; i < degree + 1; i++) {
            terms[i] = Term(0.0, i);
        }

        for (auto objTerm: obj.terms) {
            int exp = objTerm.getExponent();
            double value = objTerm.getCoefficient();
            terms[exp] = terms[exp].add(value);
        }

        for (auto term: this->terms) {
            int exp = term.getExponent();
            double value = term.getCoefficient();
            terms[exp] = terms[exp].add(value);
        }

        std::list<Term> termsList;
        for (int i = degree; i >= 0; i--) {
            if (terms[i].getCoefficient() != 0.0)termsList.push_back(terms[i]);
        }

        return Poly(termsList);
    }

    Poly operator/(double const &d) {
        std::list<Term> termsList;
        for (auto term: this->terms) {
            int exp = term.getExponent();
            double value = term.getCoefficient() / d;
            if (value != 0.0)termsList.push_back(Term(value, exp));
        }

        return Poly(termsList);
    }

    Poly operator*(double const &d) {
        std::list<Term> termsList;
        for (auto term: this->terms) {
            int exp = term.getExponent();
            double value = term.getCoefficient() * d;
            if (value != 0.0 && term.getCoefficient() != 0.0)termsList.push_back(Term(value, exp));
        }

        return Poly(termsList);
    }


    double calculate(double x) {
        double ret = 0.0;
        for (auto term: terms)ret += term.calculate(x);
        return ret;
    }

    std::string toString() {
        std::string ret;
        for (auto term: terms)ret += term.toString();
        return ret;
    }
};

#endif //ZAD2_POLYNOMIALS_H
