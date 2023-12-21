using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Counter : MonoBehaviour
{
    public Transform counterTF;
    public Transform backBorderTf;
    public Text text;
    private Color newColor;

    public void SetPosition(Vector2 _newPos)
    {
        counterTF.position = _newPos;
    }

    public void SetValues(int _startValue,int _currentValue)
    {
        StopCoroutine("FadeAway");
        if(_currentValue>9)
        {
            backBorderTf.localScale = new Vector2(1.7f,1);
        }else
        {
            backBorderTf.localScale = Vector2.one;
        }
        text.text = _currentValue.ToString();
        float currentScale = (float) _currentValue/ _startValue;

        float gFloat = currentScale;
        float rFloat = 1 - gFloat;
        newColor = new Color(rFloat,gFloat,0,255);
        text.color = newColor;

        StartCoroutine("FadeAway");
    }

    IEnumerator FadeAway()
    {
        yield return new WaitForSeconds(2);
        SetPosition(Vector2.zero);
    }
}
