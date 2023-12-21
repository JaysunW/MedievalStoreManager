using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour
{
    public Transform wholeHealthBar;
    public Transform bar;
    
    public SpriteRenderer barSprite;
    private Color barColor;
    public Text text;

    public void SetPosition(Vector2 _newPos)
    {
        wholeHealthBar.position = _newPos;
        bar.position = _newPos+new Vector2(-0.37f,0);
    }

    public void ToHighTier()
    {
        bar.localScale = new Vector3(1,1,1);
        text.text = "Too Strong";
    }

    public void SetValues(int _startValue, int _currentValue)
    {
        StopCoroutine("FadeAway");
        text.text = "";
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
        }
        StartCoroutine("FadeAway");
    }

    IEnumerator FadeAway()
    {
        yield return new WaitForSeconds(2);
        
        SetPosition(Vector2.zero);
    }
}
