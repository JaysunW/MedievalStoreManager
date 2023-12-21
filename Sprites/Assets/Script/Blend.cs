using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Blend : MonoBehaviour
{
    public static Blend Instance { get; private set; }

    public RectTransform blendTransform; 
    public Image image;
    public GameObject textObject;
    public float change = 0.01f;
    public float delay = 0.05f;
    public float loadingDelay = 0.2f;

    public string [] loadingMessage;

    private void Awake()
    {
        if(Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public float HowLongWillItBlend()
    {
        return 1/change * delay + 0.2f;
    }

    public void Start()
    {
        StartCoroutine(BlendAway());
    }

    public IEnumerator BlendAway()
    {
        StartCoroutine(Loading());
        
        yield return new WaitForSeconds(0.1f);

        blendTransform.localScale = new Vector3(1,1,1);
        image.color = new Vector4(0,0,0,1);
        float heigth = 1;
        StopCoroutine(Loading());
        textObject.active = false;
        while(heigth > 0)
        {
            blendTransform.localScale = new Vector3(1,heigth,1);
            image.color = new Vector4(0,0,1-heigth,heigth);
            heigth -= change;
            yield return new WaitForSeconds(delay);
        }
        blendTransform.localScale = new Vector3(1,0,1);
        image.color = new Vector4(0,0,0,0);
    }

    public IEnumerator BlendTo()
    {
        textObject.active = false;
        yield return new WaitForSeconds(0.1f);
        blendTransform.localScale = new Vector3(1,0,1);
        image.color = new Vector4(0,0,0,0);
        float heigth = 0;
        while(heigth < 1)
        {
            blendTransform.localScale = new Vector3(1,heigth,1);
            image.color = new Vector4(0,0,1-heigth,heigth);
            heigth += change;
            yield return new WaitForSeconds(delay);
        }
        blendTransform.localScale = new Vector3(1,1,1);
        image.color = new Vector4(0,0,0,1);
        textObject.active = true;
        StartCoroutine(Loading());
    }

    public IEnumerator Loading()
    {
        Text text = textObject.GetComponent<Text>();
        int messageTimer =0;
        while(true)
        {
            if(messageTimer == loadingMessage.Length)
                messageTimer = 0;
            text.text = "Please Wait \n Loading Assets" +loadingMessage[messageTimer];
            messageTimer++;
            yield return new WaitForSeconds(loadingDelay);
        }
    }

}
