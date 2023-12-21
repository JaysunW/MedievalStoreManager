using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FishLife : MonoBehaviour
{
    public static FishLife Instance { get; private set; }

    public RectTransform canvas;

    public RectTransform wholeHealthBar;
    public Transform bar;
    
    public Image barSprite;
    private Color barColor;

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
        wholeHealthBar.anchoredPosition = new Vector3(_newPos.x,_newPos.y,1);
    }

    public void SetValues(int _startValue, int _currentValue)
    {
        SetPosition(new Vector2(0,inView));
        StopCoroutine("FadeAway");
        if(_currentValue >= 0)
        {
            float currentScale =  (float) _currentValue/ _startValue;

            bar.localScale = new Vector3(currentScale,1,1); 

            float gFloat = currentScale;
            float rFloat = 1 - gFloat;
            barColor = new Color(rFloat,gFloat,0,255);
            barSprite.color = barColor;
            
        }else
        {
            bar.localScale = Vector3.zero;
            SetPosition(new Vector2(0,outOfView));
            StopCoroutine("FadeAway");
        }
        StartCoroutine("FadeAway");
    }

    IEnumerator FadeAway()
    {
        yield return new WaitForSeconds(2);
        SetPosition(new Vector2(0,outOfView));
    }
}
