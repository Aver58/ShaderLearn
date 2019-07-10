using UnityEngine;

//Unity3D研究院之主角面朝方向一定区域内对象角度计算（四十五）
//https://www.xuanyusong.com/archives/1977

public class MathTest : MonoBehaviour
{
    //1.已知3D坐标，和一个旋转角度，以及一段距离，求目标点的3D坐标。
    //已知当前点为Target，目标点沿着Target的Y轴旋转30度，沿着Target的X轴延伸10米求目标点的3D坐标？
    public Transform Target;
    void Awake()
    {
        //Target = transform;

        Quaternion rotation = Quaternion.Euler(0f, 30f, 0f) * Target.rotation;
        Vector3 newPos = rotation * new Vector3(10f, 0f, 0f);
        Debug.DrawLine(newPos, Vector3.zero, Color.red);
        //Debug.Log("newpos " + newPos + " nowpos " + Target.position + " distance " + Vector3.Distance(newPos, Target.position));
        //输出结果 ：新坐标(8.7, 0.0, -5.0) 当前坐标(0.0, 0.0, 0.0)两点之间的距离 10。
    }


    private float distance = 5f;
    void Update()
    {
        //if(Input.GetMouseButton(0))
        //{
        //2.已知3D模型的角度求它的向量。
        //已知3D模型Target，Y轴旋转30度后向前平移。

        //Quaternion rotation = Quaternion.Euler(0f, 30f, 0f) * Target.rotation;
        //Vector3 newPos = rotation * Vector3.forward;
        //Target.Translate(newPos.x, newPos.y, newPos.z);
        //Debug.DrawLine(newPos, Vector3.zero, Color.red);

        //3.已知一个目标点，让模型朝着这个目标点移动。
        //transform.LookAt(Target);
        //Vector3 vecn = (Target.position - transform.position).normalized;
        //vecn = Quaternion.Euler(0f, 30f, 0f) * vecn;
        //Debug.Log("vecn " + vecn);
        //transform.Translate(vecn * 0.1f);

        //4. 计算主角面前5米内所有的对象时。以主角为圆心计算面前5米外的一个点

        Quaternion r = transform.rotation;
        Vector3 f0 = (transform.position + (r * Vector3.forward) * distance);
        Debug.DrawLine(transform.position, f0, Color.red);

        //5. 计算主角面前的一个发散性的角度。假设主角看到的是向左30度，向右30度在这个区域。
        // 检测是否在扇形区域内，分成2个问题，1，是否在角度内，2，是否在半径内

        Quaternion r0 = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y - 30f, transform.rotation.eulerAngles.z);
        Quaternion r1 = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y + 30f, transform.rotation.eulerAngles.z);
        //Debug.Log("rotation " + transform.rotation);
        //Debug.Log("eulerAngles " + transform.rotation.eulerAngles);
        Vector3 f1 = (transform.position + (r0 * Vector3.forward) * distance);
        Vector3 f2 = (transform.position + (r1 * Vector3.forward) * distance);

        Debug.DrawLine(transform.position, f1, Color.red);
        Debug.DrawLine(transform.position, f2, Color.red);

        Debug.DrawLine(f0, f1, Color.red);
        Debug.DrawLine(f0, f2, Color.red);

        Vector3 point = Target.position;

        if(isInSector(point, transform, 30f * Mathf.Deg2Rad, distance))
        {
            Debug.Log("cube in this !!!");
        }
        else
        {
            Debug.Log("cube not in this !!!");
        }
    }
    bool isInSector(Vector3 TargetPoint, Transform startTransform, float angle,float radius)
    {
        Vector3 vecToTarget = TargetPoint - startTransform.position;

        float targetLength = Mathf.Sqrt(vecToTarget.x * vecToTarget.x + vecToTarget.z * vecToTarget.z);
        targetLength = Vector3.Distance(TargetPoint, startTransform.position);
        if(targetLength > radius)
            return false;

        //点积：a·b = | a || b | * cosTheta = x0 * x1 + y0 * y1 ==》cosTheta = x0 * x1 + y0 * y1 / | a || b |

        float newTheta = Mathf.Acos((vecToTarget.x * startTransform.forward.x + vecToTarget.z * startTransform.forward.z)/targetLength);
        return newTheta < angle;
    }
}