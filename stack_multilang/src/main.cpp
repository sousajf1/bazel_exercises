#include <iostream>
#include "cstack.h"
#include "revstack.h"
#include "dict.h"
#include "case.h"

using namespace std;

int main()
{
    Stack s;
    RevStack r;

    cout << Dict::clr_stack() << endl;
    s.clear();

    cout << "\t\ts.height() = " << s.height() << endl;
    cout << "\t\ts.pop()    = " << s.pop() << endl;
    cout << Dict::pushing_123() << endl;
    s.push(1);
    s.push(2);
    s.push(3);

    cout << "\t\ts.height() = " << s.height() << endl;
    cout << "\t\ts.top()    = " << s.top() << endl;

    cout << "\t\ts.pop()    = " << s.pop() << endl;
    cout << "\t\ts.pop()    = " << s.pop() << endl;
    cout << "\t\ts.pop()    = " << s.pop() << endl;
    cout << "\t\ts.height() = " << s.height() << endl;
    cout << Dict::pushing_123() << endl;
    r.push(1);
    r.push(2);
    r.push(3);
    cout << Dict::reversing() << endl;
    r.reverse();
    //cout << "\t\tr.pop()    = " << r.pop() << endl;
    //cout << "\t\tr.pop()    = " << r.pop() << endl;
    //cout << "\t\tr.pop()    = " << r.pop() << endl;
    cout << Case::pop_msg() << r.pop() << endl;
    cout << Case::pop_msg() << r.pop() << endl;
    cout << Case::pop_msg() << r.pop() << endl;

    cout << Dict::end() << endl;

    return 0;
}