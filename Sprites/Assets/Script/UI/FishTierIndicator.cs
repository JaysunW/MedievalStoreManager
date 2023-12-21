using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FishTierIndicator : MonoBehaviour
{
    public static FishTierIndicator Instance { get; private set; }

    public RectTransform canvas;
    private int outOfView = 200;
    private int inView = -90;

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

    public void Start()
    {
        SetPosition(new Vector2(0,outOfView));
    }

    public void SetPosition(Vector2 _newPos)
    {
        canvas.anchoredPosition = new Vector3(_newPos.x,_newPos.y,1);
    }

    public void SetIndicator()
    {
        SetPosition(new Vector2(0,inView));
        StopCoroutine("FadeAway");
        StartCoroutine("FadeAway");
    }

    IEnumerator FadeAway()
    {
        yield return new WaitForSeconds(2);
        SetPosition(new Vector2(0,outOfView));
    }
}
