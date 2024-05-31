using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main_angletest : MonoBehaviour
{
    public Transform left_h;
    public Transform right_h;
    public GameObject body;
    public Rigidbody a_Rigidbody;

    [SerializeField] float fly = 10f;
    [SerializeField] float downspd = 35f;
    [SerializeField] float a = -30f;
    [SerializeField] float downspd2 = 5f;

    public bool isGrounded = true;//’Ç‰Á•”•ª


    bool velociy = false;
    bool velocity2 = false;
    bool velocity3 = false;
    int ang = 0;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (isGrounded == true)
        {
            float left_Z = left_h.transform.localPosition.z;
            float right_Z = right_h.transform.localPosition.z;
            // Calculate the slope between objectA and objectB
            float slope = CalculateSlope();


            a_Rigidbody.isKinematic = false;
            a_Rigidbody.angularVelocity = Vector3.zero;
            body.transform.Translate(Vector3.forward * fly * Time.deltaTime);
           
            a_Rigidbody.AddForce(transform.up * downspd * -300f * Time.deltaTime);
            
            if (Input.GetKeyDown(KeyCode.Space))
            {
                velociy = true;
            }
            
            if (-0.09f <= left_Z && -0.09f <= right_Z)
            {
                velocity2 = false;
                velocity3 = false;
            }

            if (-0.1f >= left_Z && -0.1f >= right_Z)
            {
                velocity2 = true;
            }

            Debug.Log("left_Z" + left_Z);
            Debug.Log("right_Z" + right_Z);



            if (velociy == true)
            {
                Invoke("gofalse", 1.95f);
                body.transform.Translate(Vector3.up * fly * 1f * Time.deltaTime);
            }
            else if (velocity2 == true)
            {
                a_Rigidbody.AddForce(transform.up * fly * 14f);             //??‰º
                a_Rigidbody.AddForce(transform.forward * fly * downspd2);
            }
            else if (velocity3 == true)
            {
                Invoke("gofalse2", 0f);
                Invoke("gofalse3", 3f);

            }
            else
            {
                a_Rigidbody.velocity = Vector3.zero;
            }



            // Print the slope value
            Debug.Log("Slope: " + slope);

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
        else if(isGrounded == false)
        {
            Debug.Log("isGrounded . false");
            //a_Rigidbody.isKinematic = true;
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
    private void gofalse()
    {
        velociy = false;


    }
    private void gofalse2()
    {
        body.transform.Translate(transform.up * fly * 10f * Time.deltaTime);
    }
    private void gofalse3()
    {
        velocity3 = false;
    }
    /*
    private void OnTriggerStay(Collider other)
    {
        body.transform.Translate(Vector3.forward * fly* -1 * Time.deltaTime);
        a_Rigidbody.AddForce(transform.up * downspd * -300f* -1 * Time.deltaTime);
    }
    */

   

    private void OnTriggerEnter(Collider collider)
    {
        if (collider.gameObject.CompareTag("Ground"))
        {
            isGrounded = false;
        }
    }
    private void OnTriggerExit(Collider collider)
    {
        if (collider.gameObject.CompareTag("Ground"))
        {
            isGrounded = true;
        }
       
    }

    

    /*
    
    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Ground"))
        {
            isGrounded = false;
        }
    }

    void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.CompareTag("Ground"))
        {
            isGrounded = true;
        }
    }
    */
    
}



    