#pragma once

typedef int STACK_ITEM;

class Stack
{
public:
    Stack();
    ~Stack();
    void clear();
    unsigned height();
    void push(STACK_ITEM item);
    STACK_ITEM pop();
    STACK_ITEM top();

protected:
    STACK_ITEM &element(unsigned index);

private:
    unsigned myheight;
    unsigned size;
    STACK_ITEM *value;
};