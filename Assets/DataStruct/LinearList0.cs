using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
namespace LinearList0
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
  //顺序表类
  class SequenceList<T>:IListDS<T>
  {
    private int intMaxSize;//最大容量事先确定，使用数组必须先确定容量
    private T[] tItems;//使用数组盛放元素
    private int intPointerLast;//始终指向最后一个元素的位置
    public int MaxSize
    {
      get { return this.intMaxSize; }
      set { this.intMaxSize = value; }
    }
    public T this[int i]//索引器方便返回
    {
      get { return this.tItems[i]; }
    }
    public int PointerLast
    {
      get { return this.intPointerLast; }
    }
    public SequenceList(int size)
    {
      this.intMaxSize = size;
      this.tItems = new T[size];//在这里初始化最合理
      this.intPointerLast = -1;//初始值设为-1，此时数组中元素个数为0
    }
    public bool IsFull()//判断是否超出容量
    {
      return this.intPointerLast+1 == this.intMaxSize;
    }
    #region IListDS<T> 成员
    public int GetLength()
    {
      return this.intPointerLast + 1;//不能返回tItems的长度
    }
    public void Insert(T item, int i)//设i为第i个元素，从1开始。该函数表示在第i个元素后面插入item
    {
      if (i < 1 || i > this.intPointerLast + 1)
      {
        Console.WriteLine("The inserting location is wrong!");
        return;
      }
      if (this.IsFull())
      {
        Console.WriteLine("This linear list is full! Can't insert any new items!");
        return;
      }
      //如果可以添加
      this.intPointerLast++;
      for(int j=this.intPointerLast;j>=i+1;j--)
      {
        this.tItems[j] = this.tItems[j - 1];
      }
      this.tItems[i] = item;
    }
    public void Add(T item)
    {
      if (this.IsFull())//如果超出最大容量，则无法添加新元素
      {
        Console.WriteLine("This linear list is full! Can't add any new items!");
      }
      else
      {
        this.tItems[++this.intPointerLast] = item;//表长+1
      }
    }
    public bool IsEmpty()
    {
      return this.intPointerLast == -1;
    }
    public T GetElement(int i)//设i最小从0开始
    {
      if(this.intPointerLast == -1)
      {
        Console.WriteLine("There are no elements in this linear list!");
        return default(T);
      }
      if (i > this.intPointerLast||i<0)
      {
        Console.WriteLine("Exceed the capability!");
        return default(T);
      }
      return this.tItems[i];
    }
    public void Delete(int i)//设i最小从0开始
    {
      if (this.intPointerLast == -1)
      {
        Console.WriteLine("There are no elements in this linear list!");
        return;
      }
      if (i > this.intPointerLast || i < 0)
      {
        Console.WriteLine("Deleting location is wrong!");
        return;
      }
      for (int j = i; j < this.intPointerLast; j++)
      {
        this.tItems[j] = this.tItems[j + 1];
      }
      this.intPointerLast--;//表长-1
    }
    public void Clear()
    {
      this.intPointerLast = -1;
    }
    public int LocateElement(T item)
    {
      if (this.intPointerLast == -1)
      {
        Console.WriteLine("There are no items in the list!");
        return -1;
      }
      for (int i = 0; i <= this.intPointerLast; i++)
      {
        if (this.tItems[i].Equals(item))//若是自定义类型，则T类必须把Equals函数override
        {
          return i;
        }
      }
      Console.WriteLine("Not found");
      return -1;
    }
    public void Reverse()
    {
      if (this.intPointerLast == -1)
      {
        Console.WriteLine("There are no items in the list!");
      }
      else
      {
        int i = 0;
        int j = this.GetLength() / 2;//结果为下界整数，正好用于循环
        while (i < j)
        {
          T tmp = this.tItems[i];
          this.tItems[i] = this.tItems[this.intPointerLast - i];
          this.tItems[this.intPointerLast - i] = tmp;
          i++;
        }
      }
    }
    #endregion
  }

  class Program
  {
    static void Main(string[] args)
    {
    }
  }
}