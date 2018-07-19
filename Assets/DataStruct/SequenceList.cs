using System;
using System.Collections;
using UnityEngine;

namespace Assets.DataStruct
{
    public interface IListDS<T>
    {
        int GetLength();
        void Insert(T item, int i);
        void Add(T item);
        bool IsEmpty();
        void Delete(int i);
        void Clear();
        int Index(T item);
        void Reverse();
    }
    class SequenceList<T> : IListDS<T>, IEnumerable
    {
        public IEnumerator GetEnumerator()
        {
            throw new NotImplementedException();
        }

        private int MaxSize
        {
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

        public bool IsFull()
        {
            return m_LastPointer + 1 == m_Size;
        }

        public T this[int i]//索引器方便返回
        {
            get { return m_Items[i]; }
            set { m_Items[i] = value; }
        }

        public bool IsEmpty()
        {
            return m_LastPointer == -1;
        }

        public void Insert(T item, int i)
        {
            if (IsFull())
            {
                Debug.LogError("This linear list is full! Can't insert any new items!");
                return;
            }
            if (i >= m_LastPointer || i < 0)
            {
                Debug.LogError("Out Of Index!");
                return;
            }

            m_LastPointer++;
            //把插入位置后面的item(i+1,m_LastPointer)往后挪1个位置
            for (int j = m_LastPointer; j >= i + 1; j--)
            {
                m_Items[j] = m_Items[j - 1];
            }
            m_Items[i] = item;

        }
        public void Delete(int i)
        {
            if (IsEmpty())
            {
                Debug.LogError("IsEmpty");
                return;
            }
            if (i >= m_LastPointer || i < 0)
            {
                Debug.LogError("Stack Overfolw!");
                return;
            }
            //把删除位置后面的item(i,m_LastPointer)往前挪1个位置
            for (int j = i; j < m_LastPointer; j++)
            {
                m_Items[j] = m_Items[j + 1];
            }
            m_LastPointer--;

        }

        public void Add(T item)
        {
            if (IsFull())
            {
                Debug.LogError("This linear list is full! Can't insert any new items!");
                return;
            }
            m_Items[++m_LastPointer] = item;
        }

        public void Clear()
        {
            if (IsEmpty())
            {
                Debug.LogError("IsEmpty");
                return;
            }
            m_Items = new T[m_Size];
            m_LastPointer = -1;
        }

        public int Index(T item)
        {
            if (IsEmpty())
            {
                Debug.LogError("IsEmpty");
                return -1;
            }
            for (int i = 0; i < m_LastPointer; i++)
            {
                if (item.Equals(this[i]))
                {
                    return i;
                }
            }
            Console.WriteLine("Not found");
            return -1;
        }

        public void Reverse()
        {
            if (IsEmpty())
            {
                Debug.LogError("IsEmpty");
                return;
            }
            //int L_Pointer = 0;
            //int R_Pointer = m_LastPointer;
            //T temp;
            //for (int i = 0; i < m_LastPointer/2; i++)
            //{
            //    temp = this[L_Pointer];
            //    this[L_Pointer] = this[R_Pointer];
            //    this[R_Pointer] = temp;
            //    L_Pointer--;
            //    R_Pointer--;
            //}
            int i = 0;
            int j = GetLength() / 2;//结果为下界整数，正好用于循环
            while (i < j)
            {
                T tmp = this[i];
                this[i] = this[m_LastPointer - i];
                this[m_LastPointer - i] = tmp;
                i++;
            }
        }
    }


    class Program
    {
        static void Main(string[] args)
        {
            SequenceList<int> list = new SequenceList<int>(10);
            list.Add(1);
            list.Add(2);
            foreach (var item in list)
            {
                Console.WriteLine(item);
            }
        }
    }
}
