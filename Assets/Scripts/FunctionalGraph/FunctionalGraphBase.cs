using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets.Editor
{
    //序列化该类型
    [Serializable]
    public class FunctionalGraphBase
    {
        /// <summary>
        /// 是否显示X轴
        /// </summary>
        public bool ShowXAxis = true;
        /// <summary>
        /// 是否显示Y轴
        /// </summary>
        public bool ShowYAxis = true;
        /// <summary>
        /// 是否显示刻度
        /// </summary>
        public bool ShowScale = false;
        /// <summary>
        /// 是否显示XY轴单位
        /// </summary>
        public bool ShowXYAxisUnit = true;
        /// <summary>
        /// X轴单位
        /// </summary>
        public string XAxisUnit = "X";
        /// <summary>
        /// Y轴单位
        /// </summary>
        public string YAxisUnit = "Y";
        /// <summary>
        /// XY轴刻度
        /// </summary>
        [Range(0.1f, 100f)] public float XYAxisScale = 50f;
        /// <summary>
        /// XY轴宽度
        /// </summary>
        [Range(0.1f, 100f)] public float XYAxisWidth = 5.0f;
        /// <summary>
        /// XY轴颜色
        /// </summary>
        public Color XYAxisColor = Color.gray;
        /// <summary>
        /// 是否显示XY轴的箭头
        /// </summary>
        public bool ShowXYAxisArrow = true;
        /// <summary>
        /// 箭头尺寸
        /// </summary>
        public float ArrowSzie = 3.0f;
    }
}
