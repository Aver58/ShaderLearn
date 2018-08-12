using Assets.Editor;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FunctionalGraph : MaskableGraphic
{
    public FunctionalGraphBase GraphBase = new FunctionalGraphBase();
    public List<FunctionFormula> Formulas = new List<FunctionFormula>();
    private RectTransform _myRect;

    /// <summary>
    /// 初始化函数信息，添加了五个函数公式
    /// </summary>
    private void Init()
    {
        _myRect = this.rectTransform;
        Formulas.Add(new FunctionFormula(Mathf.Sin, Color.red, 3.0f));
        Formulas.Add(new FunctionFormula(Mathf.Cos, Color.green, 2.0f));
        Formulas.Add(new FunctionFormula(Mathf.Sign, Color.blue, 2.0f));
        Formulas.Add(new FunctionFormula(Mathf.Sqrt, Color.magenta, 2.0f));
        Formulas.Add(new FunctionFormula(xValue => xValue * 1.3f + 1, Color.yellow, 2.0f));
    }

    /// <summary>
    /// 重写这个类以绘制UI，首先初始化数据和清空已有的顶点数据
    /// </summary>
    /// <param name="vh"></param>
    protected override void OnPopulateMesh(VertexHelper vh)
    {
        Init();
        vh.Clear();

        #region 基础框架的绘制

        //绘制X轴,获取X轴左右两个顶点，绘制一个矩形
        if (GraphBase.ShowXAxis)
        {
            float lenght = _myRect.sizeDelta.x;
            Vector2 leftPoint = new Vector2(-lenght / 2.0f, 0);
            Vector2 rightPoint = new Vector2(lenght / 2.0f, 0);
            vh.AddUIVertexQuad(GetQuad(leftPoint, rightPoint, GraphBase.XYAxisColor, GraphBase.XYAxisWidth));
            // 绘制X轴的箭头
            // 箭头的绘制和矩形一样，只要传入四个顶点即可，见三角形的绘制详解图利用ABCD四个点绘制
            if (GraphBase.ShowXYAxisArrow)
            {
                float arrowUnit = GraphBase.ArrowSzie / 2.0f;
                Vector2 firstPoint = rightPoint + new Vector2(0, arrowUnit);
                Vector2 secondPoint = rightPoint;
                Vector2 thirdPoint = rightPoint + new Vector2(0, -arrowUnit);
                Vector2 fourPoint = rightPoint + new Vector2(Mathf.Sqrt(3) * arrowUnit, 0);
                vh.AddUIVertexQuad(GetQuad(firstPoint, secondPoint, thirdPoint, fourPoint, GraphBase.XYAxisColor));
            }
        }
        //绘制Y轴,获取Y轴上下两个顶点，绘制一个矩形
        if (GraphBase.ShowYAxis)
        {
            float height = _myRect.sizeDelta.y;
            Vector2 downPoint = new Vector2(0, -height / 2.0f);
            Vector2 upPoint = new Vector2(0, height / 2.0f);
            vh.AddUIVertexQuad(GetQuad(downPoint, upPoint, GraphBase.XYAxisColor, GraphBase.XYAxisWidth));
            // 绘制Y轴的箭头
            if (GraphBase.ShowXYAxisArrow)
            {
                float arrowUnit = GraphBase.ArrowSzie / 2.0f;
                Vector2 firstPoint = upPoint + new Vector2(arrowUnit, 0);
                Vector2 secondPoint = upPoint;
                Vector2 thirdPoint = upPoint + new Vector2(-arrowUnit, 0);
                Vector2 fourPoint = upPoint + new Vector2(0, Mathf.Sqrt(3) * arrowUnit);
                vh.AddUIVertexQuad(GetQuad(firstPoint, secondPoint, thirdPoint, fourPoint, GraphBase.XYAxisColor));
            }
        }

        #endregion

        #region 函数图的绘制
        //遍历函数公式，然后每隔一次像素绘制一个矩形
        foreach (var functionFormula in Formulas)
        {
            Vector2 startPos = GetFormulaPoint(functionFormula.Formula, -_myRect.sizeDelta.x / 2.0f);
            //从X轴的负方向轴开始向正方向轴绘制
            for (float x = -_myRect.sizeDelta.x / 2.0f + 1; x < _myRect.sizeDelta.x / 2.0f; x++)
            {
                Vector2 endPos = GetFormulaPoint(functionFormula.Formula, x);
                vh.AddUIVertexQuad(GetQuad(startPos, endPos, functionFormula.FormulaColor, functionFormula.FormulaWidth));
                //这里把当前绘制的结束点设置为下一次绘制的起始点
                startPos = endPos;
            }
        }

        #endregion
    }

    //通过两个端点绘制矩形
    private UIVertex[] GetQuad(Vector2 startPos, Vector2 endPos, Color color0, float lineWidth = 2.0f)
    {
        float dis = Vector2.Distance(startPos, endPos);
        float y = lineWidth * 0.5f * (endPos.x - startPos.x) / dis;
        float x = lineWidth * 0.5f * (endPos.y - startPos.y) / dis;
        if (y <= 0) y = -y;
        else x = -x;
        UIVertex[] vertex = new UIVertex[4];
        vertex[0].position = new Vector3(startPos.x + x, startPos.y + y);
        vertex[1].position = new Vector3(endPos.x + x, endPos.y + y);
        vertex[2].position = new Vector3(endPos.x - x, endPos.y - y);
        vertex[3].position = new Vector3(startPos.x - x, startPos.y - y);
        for (int i = 0; i < vertex.Length; i++) vertex[i].color = color0;
        return vertex;
    }

    //通过四个顶点绘制矩形
    private UIVertex[] GetQuad(Vector2 first, Vector2 second, Vector2 third, Vector2 four, Color color0)
    {
        UIVertex[] vertexs = new UIVertex[4];
        vertexs[0] = GetUIVertex(first, color0);
        vertexs[1] = GetUIVertex(second, color0);
        vertexs[2] = GetUIVertex(third, color0);
        vertexs[3] = GetUIVertex(four, color0);
        return vertexs;
    }

    //构造UIVertex
    private UIVertex GetUIVertex(Vector2 point, Color color0)
    {
        UIVertex vertex = new UIVertex
        {
            position = point,
            color = color0,
            uv0 = new Vector2(0, 0)
        };
        return vertex;
    }

    //利用Func委托，计算出每一个绘制点
    private Vector2 GetFormulaPoint(Func<float, float> formula, float xValue)
    {
        return new Vector2(xValue, formula(xValue / GraphBase.XYAxisScale) * 50);
    }
}
