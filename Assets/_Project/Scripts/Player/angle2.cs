using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class angle2 : MonoBehaviour
{

    public Transform left_h;
    public Transform right_h;
    public GameObject body;
    public Rigidbody a_Rigidbody;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float left_Z = left_h.transform.localPosition.z;
        float right_Z = right_h.transform.localPosition.z;
        // Calculate the slope between objectA and objectB
        float slope = CalculateSlope();
        a_Rigidbody.AddForce(transform.up * Time.deltaTime);

      /*  if (-0.09f <= left_Z && -0.09f <= right_Z)
        {
            a_Rigidbody.AddForce(transform.up * -0.1f);
        }

        if (-0.1f >= left_Z && -0.1f >= right_Z)
        {
            a_Rigidbody.AddForce(transform.up * -0.1f);
        }
      */
        if (-0.21f <= slope && slope <= 0.21f)
        {

        }
        else if (slope >= 0.22f)
        {
            body.transform.Rotate(new Vector3(0f, -10f, 0f) * Time.deltaTime);
        }
        else if (slope >= 0.32f)
        {
            body.transform.Rotate(new Vector3(0f, -30f, 0f) * Time.deltaTime);
        }

        else if (slope <= -0.22f)
        {
            body.transform.Rotate(new Vector3(0f, 10f, 0f) * Time.deltaTime);
        }
        else if (slope <= -0.32f)
        {
            body.transform.Rotate(new Vector3(0f, 30f, 0f) * Time.deltaTime);
        }
        else
        {

        }
    }

    private float CalculateSlope()
    {
        // Calculate the difference in Y position
        float deltaY = left_h.localPosition.y - right_h.localPosition.y;

        // Calculate the difference in X position
        float deltaX = left_h.localPosition.x - right_h.localPosition.x;

        // Calculate the slope using deltaY / deltaX
        float slope = deltaY / deltaX;

        return slope;
    }
}
