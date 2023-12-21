using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class O2VolumeUI : MonoBehaviour
{
    public GameObject O2AirInTank;

    private int o2Start;

    private int o2GaigeSize = 204;

    public void SetStartO2(int _o2Amount)
    {
        o2Start = _o2Amount;
    }

    public void O2change(int _o2Amount)
    {
        RectTransform O2AirTransform = O2AirInTank.GetComponent<RectTransform>();
        if(_o2Amount > 0)
        {
            float o2Percentage = (float) _o2Amount/ o2Start;
            O2AirTransform.sizeDelta = new Vector2(O2AirTransform.sizeDelta.x, (o2GaigeSize * o2Percentage));
            O2AirTransform.anchoredPosition = new Vector2(O2AirTransform.anchoredPosition.x,(-o2GaigeSize +(o2GaigeSize * o2Percentage))/2);
        }else 
        {
            O2AirTransform.sizeDelta = new Vector2(O2AirTransform.sizeDelta.x, 0);
            O2AirTransform.anchoredPosition = new Vector2(O2AirTransform.anchoredPosition.x,-o2GaigeSize/2);
        }
    }
}
