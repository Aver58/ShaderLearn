using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Assets.DataStruct
{
    public interface IListDS<T>
    {
        int GetLength();
        void Insert(T item, int i);
        void Add(T item);
        bool IsEmpty();
        T GetElement(int i);
        void Delete(int i);
        void Clear();
        int LocateElement(T item);
        void Reverse();
    }
    class SequenceList<T> : IListDS<T>
    {
        private int MaxSize{
            get { return items.Length; }
            set { m_maxSize = value; }
        }
        private int LastPointer;
        private int m_maxSize;
        private T[] items;

        //构造
        public SequenceList(int size)
        {
            m_maxSize = size;
            items = new T[size];
            //初始值设为-1，此时数组中元素个数为0
            LastPointer = -1;
        }

        public int GetLength()
        {
            //不能返回tItems的长度
            //return MaxSize;
            return LastPointer + 1;
        }

        public void Insert(T item, int i)
        {
            throw new NotImplementedException();
        }

        public void Add(T item)
        {
            throw new NotImplementedException();
        }

        public bool IsEmpty()
        {
            throw new NotImplementedException();
        }

        public T GetElement(int i)
        {
            throw new NotImplementedException();
        }

        public void Delete(int i)
        {
            throw new NotImplementedException();
        }

        public void Clear()
        {
            throw new NotImplementedException();
        }

        public int LocateElement(T item)
        {
            throw new NotImplementedException();
        }

        public void Reverse()
        {
            throw new NotImplementedException();
        }
    }
}
