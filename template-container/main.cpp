#include <iostream>

template <typename T>
struct list
{
    struct node {
        node() : next(0) {}
        node* next;
        T value;
    };
    list() : head(0), tail(0)
    {
    }
    void append(T val)
    {
        node* n = new node;
        n->value = val;
        if (tail)
        {
            tail->next = n;
        }
        tail = n;
        if (!head)
        {
            head = n;
        }
    }
    struct iterator
    {
        iterator(struct node* position)
            : n(position)
        {
        }
        iterator& operator++()
        {
            if (n)
            {
                n = n->next;
            }
            return *this;
        }
        T operator*()
        {
            if (n)
            {
                return n->value;
            }
            /* throw */
            return 0;
        }
        bool operator!=(const iterator& rhs)
        {
            return this->n != rhs.n;
        }
    private:
        node* n;
    };
    iterator begin()
    {
        return iterator(head);
    }
    iterator end()
    {
        return iterator(0);
    }
private:
    node* head;
    node* tail;
};

int main()
{
    list<int> a;
    a.append(10);
    a.append(20);
    a.append(30);
    a.append(40);
    for(
        list<int>::iterator i = a.begin();
        i != a.end();
        ++i
    )
    {
        std::cout << "*i = " << (*i) << std::endl;
    }
    return 0;
}
