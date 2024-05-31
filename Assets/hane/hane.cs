using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class hane : MonoBehaviour
{

    private bool h = false;
    GameObject cube;

    // Start is called before the first frame update
    void Start()
    {
        cube = GetComponent<GameObject>();
        gameObject.SetActive(true);
        h = false;
    }

    // Update is called once per frame
    void Update()
    {
        gameObject.transform.Rotate(new Vector3(0f, 0f, 100f) * Time.deltaTime);

    }
    private void OnTriggerEnter(Collider other)
    {
        // Check if the entering collider has a specific tag (e.g., "Player").
        if (other.CompareTag("Player"))
        {
            // Deactivate the GameObject this script is attached to.
            gameObject.SetActive(false);

            // Alternatively, you can destroy the GameObject:
            // Destroy(gameObject);
        }
    }
}

