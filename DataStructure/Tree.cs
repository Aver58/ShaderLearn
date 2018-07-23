using System;
using System.Collections.Generic;
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
    //3.树的表现
    //①儿子-兄弟表示
    public class Son_SiblingNode
    {
        // 二叉树
        Son_SiblingNode First_Child;
        Son_SiblingNode Next_Sibling;

    }
    class Tree
    {
    }
}
