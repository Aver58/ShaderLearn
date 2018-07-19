using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

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
            get { return m_Items.Length; }
            set { m_Size = value; }
        }
        private int m_LastPointer;
        private int m_Size;
        private T[] m_Items;

        //构造
        public SequenceList(int size)
        {
            m_Size = size;
            m_Items = new T[size];
            //初始值设为-1，此时数组中元素个数为0
            m_LastPointer = -1;
        }

        public int GetLength()
        {
            //不能返回tItems的长度
            //return MaxSize;
            return m_LastPointer + 1;
        }

        public void Insert(T item, int i)
        {
            if (m_Size <= i)
            {
                Debug.LogError("Stack Overfolw!");
            }
            else if(m_LastPointer < i)
            {
                Debug.LogError("Out Of Index!");
            }
            else
            {

            }
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
