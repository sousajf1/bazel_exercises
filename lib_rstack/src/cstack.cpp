#include "cstack.h"

int const SIZE_STEP = 40;

Stack::Stack() : myheight(0),
                 size(0),
                 value(0)
{
}

Stack::~Stack()
{
    delete[] value;
}

void Stack::clear()
{
    myheight = 0;
}

unsigned Stack::height()
{
    return myheight;
}

void Stack::push(
    STACK_ITEM item)
{
    if (myheight >= size)
    {
        size += SIZE_STEP;
        STACK_ITEM *new_value = new STACK_ITEM[size];
        for (unsigned i = 0; i < myheight; i++)
            new_value[i] = value[i];
        delete[] value;
        value = new_value;
    }
    value[myheight++] = item;
}

STACK_ITEM Stack::pop()
{
    STACK_ITEM item = -2147483648;

    if (myheight > 0)
        item = value[--myheight];

    return item;
}

STACK_ITEM Stack::top()
{
    STACK_ITEM item = -2147483648;

    if (myheight > 0)
        item = value[myheight - 1];

    return item;
}

STACK_ITEM &Stack::element(unsigned index) { return value[index]; }