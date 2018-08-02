using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataStructure
{
    public interface IHeap
    {
        int GetLength();
        bool IsEmpty();
        bool IsFull();
        void Clear();
        //Node<T> Find(int i);
        //int Index(T node);
        //void Add(T item);
        //void Delete(int i);
        void Insert(int data, int index);
        //void Reverse();
    }

    public class HeapNode
    {
        public int data;          //数据域
        public HeapNode next;    //指针域

        public HeapNode() { }

        public HeapNode(int value)
        {
            data = value;
        }
    }

    class HeapBase: IHeap
    {
        private int m_size;
        private int m_capacity;
        private HeapNode m_headNode;
        public HeapBase(int maxSize)
        {
            m_capacity = maxSize;
            m_size++;
        }

        public void Clear()
        {
            throw new NotImplementedException();
        }

        public int GetLength()
        {
            return m_size;

        }

        public void Insert(int data, int index)
        {
            throw new NotImplementedException();
        }

        public bool IsEmpty()
        {
            return m_size == 0;
        }

        public bool IsFull()
        {
            return m_size >= m_capacity;
        }
    }

    class MaxHeap : HeapBase
    {
        //最大堆
        //public MaxHeap(int value)
        //{
        //}
    }
    class MinHeap : HeapBase
    {
        //最小堆
    }
}
