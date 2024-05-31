using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class countdown : MonoBehaviour

{
    public float countdownTime = 61; // Set the initial countdown time in seconds
    public TMP_Text countdownText; // Reference to a UI Text component to display the countdown
    public GameObject count;
    public CanvasGroup cg;
    private float currentTime;
    private bool isCounting = false;
    public float fadeDuration = 3.0f;

    private void Start()
    {
        // Initialize the timer
        currentTime = countdownTime;
        UpdateUI();
        isCounting = true;
        count.SetActive(true);
    }

    private void Update()
    {
        
        float startAlpha = cg.alpha;

        if (isCounting == true)
        {
            // Update the countdown timer
            currentTime -= Time.deltaTime;


            if (currentTime >= 60)
            {
                //count.SetActive(false);
                cg.alpha = 0f;
            }
            if (59 <= currentTime && currentTime <= 60)
            {
               // count.SetActive(true);
               // count.SetActive(false);
                cg.alpha += 3* Time.deltaTime;
            }
            if (59 <= currentTime && currentTime <= 60)
            {
               // count.SetActive(true);
            }
            if (57 <= currentTime && currentTime <= 59)
            {
                cg.alpha -= 0.5f * Time.deltaTime;
            }


            if (31 <= currentTime && currentTime <= 57)
            {
               // count.SetActive(false);
                cg.alpha = 0f;
            }
            if (29 <= currentTime && currentTime <= 30)
            {
                cg.alpha += 3 * Time.deltaTime;
            }
            if (27 <= currentTime && currentTime <= 29)
            {
                cg.alpha -= 0.5f * Time.deltaTime;
            }


            if (10 <= currentTime && currentTime <= 27)
            {
                cg.alpha = 0f;
               // count.SetActive(false);
            }
            if (9 <= currentTime && currentTime <= 10)
            {
                cg.alpha += 3 * Time.deltaTime;
            }
            if (currentTime <= 10)
            {
                count.SetActive(true);
            }
            if (currentTime <= 0)
            {
                // The countdown has reached zero
                currentTime = 0;
                SceneManager.LoadScene("badending");
                isCounting = false;
                // Handle countdown completion, e.g., trigger an event or perform an action
            }

            UpdateUI();
            Debug.Log(" countdownTime" + countdownTime);
        }
        
    }

    private void UpdateUI()
    {
        // Update the UI text to display the current time
        if (countdownText != null)
        {
            countdownText.text = Mathf.Ceil(currentTime).ToString(); // Display the time as an integer
        }
    }

   /* private IEnumerator FadeOutCoroutine()
    {
        float startAlpha = cg.alpha;
        float timeElapsed = 0.0f;

        while (timeElapsed < fadeDuration)
        {
            // Calculate the new alpha value based on the time elapsed
            float newAlpha = Mathf.Lerp(startAlpha, 0.0f, timeElapsed / fadeDuration);

            // Update the Canvas Group's alpha value
            cg.alpha = newAlpha;

            // Increase the time elapsed
            timeElapsed += Time.deltaTime;

            yield return null;
        }

        // Ensure the alpha is set to 0 when the fade is complete
        cg.alpha = 0.0f;
    }
   */


}
