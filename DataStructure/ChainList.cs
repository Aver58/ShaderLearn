using System;
using System.Collections;

namespace DataStructure
{
    public interface IChainList<T>
    {
        int GetLength();
        bool IsEmpty();
        void Clear();
        int Index(T item);
        void Add(T item);
        void Delete(int i);
        void Insert(T item, int i);
        void Reverse();
    }

    //结点类
    public class Node<T>
    {
        public T data;          //数据域
        public Node<T> next;    //指针域

        public Node() { }

        public Node(T value)
        {
            data = value;
        }
    }

    //struct Nodes<T>
    //{
    //    T data;
    //    Nodes<T> next;
    //}

    /// <summary>
    /// 线性表的链式实现    -- 2018/7/20
    /// 单链表
    /// </summary>
    class ChainList<T> : IChainList<T>, IEnumerable
    {
        private Node<T> m_HeadNode;
        private Node<T>[] m_Items;
        private int m_LastPointer = -1;
        private int m_Size;

        public ChainList()
        {
            m_HeadNode = new Node<T>();
            m_HeadNode.next = null;
            m_LastPointer = -1;
        }
        public ChainList(T data)
        {
            //创建头结点
            m_HeadNode = new Node<T>();
            m_HeadNode.next = null;
            m_HeadNode.data = data;
            m_LastPointer = 0;
            m_Items[m_LastPointer] = m_HeadNode;
        }

        //输出线性表
        public void PrintNodes<T>()
        {
            var tempNode = m_HeadNode.next;
            if (m_HeadNode.next == null)
            {
                Console.WriteLine("Current List Is Null!");
                return;
            }
            while (tempNode != null)
            {
                Console.Write(tempNode.data + " ");
                tempNode = tempNode.next;
            }
            Console.WriteLine();
        }

        public IEnumerator GetEnumerator()
        {
            foreach (var val in m_Items)
            {
                yield return val;
            }
        }

        public int GetLength()
        {
            int len = 0;
            var tempNode = m_HeadNode.next;

            //时间性能为 O(n)。
            while (tempNode != null)
            {
                len++;
            }
            return len;
        }

        public bool IsEmpty()
        {
            var tempNode = m_HeadNode.next;
            if (tempNode == null)
            {
                return true;
            }
            return false;
        }

        public void Clear()
        {
            m_HeadNode = new Node<T>();
            m_HeadNode.next = null;
            for (int i = 0; i < m_LastPointer; i++)
            {
                m_Items[i] = null;
            }
        }

        public void Add(T item)
        {
            throw new NotImplementedException();
        }

        public void Delete(int i)
        {
            throw new NotImplementedException();
        }

        public void Insert(T item, int i)
        {
            throw new NotImplementedException();
        }

        public void InsertTop<T>(Node<T> node)
        {

        }

        public void InsertBottom<T>(Node<T> node)
        {

        }

        public int Find(int i)
        {

        }

        public void Reverse()
        {
            throw new NotImplementedException();
        }



    }

    class Program
    {
        static void Main(string[] args)
        {
            //SequenceList<int> list = new SequenceList<int>(10);
            //list.Add(1);
            //list.Add(2);
            //foreach (var item in list)
            //{
            //    Console.WriteLine(item);
            //}

            //Console.WriteLine(list.GetLength());
            //Console.WriteLine(list.IsFull());
            //Console.WriteLine(list.IsEmpty());
            //Console.WriteLine(list[1]);

            //Console.Clear();

            //list.Insert(100, 0);
            //list.Insert(22, 1);

            //list.Delete(0);
            //Console.WriteLine(list.GetLength());
            //foreach (var item in list)
            //{
            //    Console.WriteLine(item);
            //}
            //Console.ReadLine();
        }
    }
}
