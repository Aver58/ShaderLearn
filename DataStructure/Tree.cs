using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataStructure
{
    /*
            1. 判定树上每个结点需要的查找次数刚好为该结点所在的层数; 
            2. 查找成功时查找次数不会超过判定树的深度
            3. n个结点的判定树的深度为[log2n]+1.

            4. 子树是不相交的；
          5. 除了根结点外，每个结点有且仅有一个父结点；
          6. 一棵N个结点的树有N-1条边。
     */



    /*
      树的一些基本术语
          1. 结点的度（Degree）：结点的子树个数
          2. 树的度：树的所有结点中最大的度数
          3. 叶结点（Leaf）：度为0的结点
          4. 父结点（Parent）：有子树的结点是其子树
              的根结点的父结点
          5. 子结点（Child）：若A结点是B结点的父结
              点，则称B结点是A结点的子结点；子结点也
              称孩子结点。
          6. 兄弟结点（Sibling）：具有同一父结点的各
              结点彼此是兄弟结点。        7. 路径和路径长度：从结点n1到nk的路径为一
              个结点序列n1 , n2
              ,… , nk
              , ni是 ni+1的父结
              点。路径所包含边的个数为路径的长度。
          9. 祖先结点(Ancestor)：沿树根到某一结点路
              径上的所有结点都是这个结点的祖先结点。
          10. 子孙结点(Descendant)：某一结点的子树
              中的所有结点是这个结点的子孙。
          11. 结点的层次（Level）：规定根结点在1层，
              其它任一结点的层数是其父结点的层数加1。
          12. 树的深度（Depth）：树中所有结点中的最
              大层次是这棵树的深度
       */
    // 3.1树的表现
        //①儿子-兄弟表示
    public class Son_SiblingNode
    {
        // 二叉树
        Son_SiblingNode First_Child;
        Son_SiblingNode Next_Sibling;
    }


    // 3.2二叉树的存储结构
    //      1. 顺序存储
            //①完全二叉树：按从上至下、从左到右顺序存储
            //①一般二叉树：但会造成空间浪费
    //      2. 链式存储

    public class TreeNode
    {
        public int data;
        public TreeNode left;
        public TreeNode right;

        public TreeNode(){}

        public TreeNode(int value)
        {
            data = value;
        }
        public void DisplayData()
        {
            Console.Write(data + " ");
        }
    }

    public interface ITree<T>
    {
        int GetLength();
        bool IsEmpty();
        void Clear();
        Node<T> Find(int i);
        int Index(T node);
        void Add(T item);
        void Delete(int i);
        void Insert(T item, int i);
        void Reverse();
    }

    class Tree
    {
        private TreeNode m_HeadNode;
        private int m_Size = 0;

        public Tree() { }

        public Tree(int data)
        {
            m_HeadNode = new TreeNode(data);
            m_HeadNode.left = null;
            m_HeadNode.right = null;
            m_Size++;
        }

        // 3.3 二叉树的遍历

        //以ABCDEFGHI为例子

        // (1)先序遍历:
        // ①先访问根节点
        // ②先序遍历左子树
        // ③先序遍历右子树

        // 先序遍历递归版
        public void PreOrder(TreeNode tree)
        {
            if (tree == null)
            {
                return;
            }
            tree.DisplayData();
            PreOrder(tree.left);
            PreOrder(tree.right);
        }

        // (2)中序遍历
        public void InOrder(TreeNode tree)
        {
            if (tree == null)
            {
                return;
            }
            InOrder(tree.left);
            tree.DisplayData();
            InOrder(tree.right);
        }

        // (3)后序遍历
        public void PostOrder(TreeNode tree)
        {
            if (tree == null)
            {
                return;
            }
            PostOrder(tree.left);
            PostOrder(tree.right);
            tree.DisplayData();
        }

        // (4)层序遍历
        //从根节点开始入队，开始循环：（结点出队、访问该结点、其左右儿子入队）
        public void LevelOrder(Tree tree)
        {
            if (tree == null)
            {
                return;
            }
            Queue<int> queue = new Queue<int>();
            queue.Enqueue(tree.data);
        }
        // 先序遍历非递归版
        //public void PreOrderEasy(TreeNode tree)
        //{
        //    if (tree == null)
        //    {
        //        return;
        //    }
        //    Stack<TreeNode> stack = new Stack<TreeNode>();
        //    TreeNode node = tree;
        //    while (node != null||stack.Any())
        //    {
        //        if (node != null)
        //        {
        //            stack.Push(node);/*一直向左并将沿途结点压入堆栈*/
        //            node.DisplayData();
        //            node = node.left;
        //        }
        //        else
        //        {
        //            var item = stack.Pop();/*结点弹出堆栈*/
        //            node = item.right;/*转向右子树*/
        //        }
        //    }
        //}

        public int GetLength()
        {
            return m_Size;
        }

        //求树的高度
        public int GetHeight()
        {
            int HeightL = 0, HeightR = 0, MaxHeight = 0;
            TreeNode tempNode = new TreeNode();
            tempNode = m_HeadNode;
            while (tempNode != null)
            {
                tempNode = tempNode.left;
                HeightL += 1;
            }
            tempNode = m_HeadNode;
            if (tempNode!=null)
            {
                tempNode = tempNode.left;
                HeightR += 1;
            }
            return Math.Max(HeightL, HeightR);
        }

        public bool IsEmpty()
        {
            return m_Size == 0;
        }

        public void Clear()
        {
            m_HeadNode = new TreeNode();
            m_HeadNode.left = null;
            m_HeadNode.right = null;
            m_Size = 0;
        }

        public TreeNode FindMax()
        {
            TreeNode tempNode = new TreeNode();
            tempNode = m_HeadNode;
            while (tempNode != null)
            {
                tempNode = tempNode.right;
            }
            return tempNode;
        }

        public TreeNode FindMin()
        {
            TreeNode tempNode = new TreeNode();
            tempNode = m_HeadNode;
            while (tempNode != null)
            {
                tempNode = tempNode.left;
            }
            return tempNode;
        }

        public TreeNode Find(int i)
        {
            TreeNode tempNode = new TreeNode();
            tempNode = m_HeadNode;
            while (tempNode!=null)
            {
                if (i < tempNode.data)
                {
                    tempNode = tempNode.left;
                }
                else if (i > tempNode.data)
                {
                    tempNode = tempNode.right;
                }
                else
                {
                    return tempNode;
                }
            }
            return null;
        }

        public int Index(T node)
        {
            throw new NotImplementedException();
        }

        public void Add(T item)
        {
            throw new NotImplementedException();
        }

        // 二叉树的删除是最麻烦的，需要考虑四种情况：
        // 被删节点是叶子节点
        // 被删节点有左孩子没右孩子
        // 被删节点有右孩子没左孩子
        // 被删节点有两个孩子
        public void Delete(int i)
        {
            throw new NotImplementedException();
        }

        public void Insert(int item)
        {
            TreeNode newNode = new TreeNode(item);
            if (m_HeadNode == null)
            {
                m_HeadNode = newNode;
                return;
            }
            TreeNode tempNode = m_HeadNode;
            while (tempNode!=null)
            {
                if (newNode.data < tempNode.data)
                {
                    tempNode = tempNode.left;
                    if (tempNode==null)
                    {
                        tempNode.left = newNode;
                        break;
                    }
                }
                else
                {
                    tempNode = tempNode.right;
                    if (tempNode == null)
                    {
                        tempNode.right = newNode;
                        break;
                    }
                }
            }
           
        }

        public void Reverse()
        {
            throw new NotImplementedException();
        }


    }
    class Program
    {
        //public static Tree<T> CreatFakeTree()
        //{
        //    Tree<T> tree = new Tree<T>() { Value = "A" };
        //    tree.Left = new Tree<T>()
        //    {
        //        Value = "B",
        //        Left = new Tree<T>() { Value = "D", Left = new Tree<T>() { Value = "G" } },
        //        Right = new Tree<T>() { Value = "E", Right = new Tree<T>() { Value = "H" } }
        //    };
        //    tree.Right = new Tree<T>() { Value = "C", Right = new Tree<T>() { Value = "F" } };

        //    return tree;
        //}
        static void Main(string[] args)
        {
            Tree<int> tree = new Tree<int>();
            
            //list.Add(2);
            //list.Add(3);
            //list.Add(4);
            //list.Add(5);
            //list.Delete(2);

            //Console.WriteLine(list.Find(1).data);
            //Console.WriteLine(list.Index(4));

            //list.Insert(10,2);
            //list.Insert(100, 0);

            //list.InsertTop(10);

            //Console.WriteLine(list.GetLength());
            //Console.WriteLine(list.IsEmpty());

            //Console.Clear();

            Console.ReadLine();
        }
    }
}
