using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GoldUI : MonoBehaviour
{
    public GameObject goldText;
    public GameObject goldTextTransform;

    public void ChangeGoldUI(int _goldAmount)
    {
        //goldTextTransform.GetComponent<RectTransform>().anchoredPosition = new Vector2(56,28);

        Text goldTextUI = goldText.GetComponent<Text>();
        goldTextUI.fontSize = 300;
        if(_goldAmount < 1000)
        {
            goldTextUI.text = _goldAmount.ToString();
        }else if(_goldAmount >= 1000 && _goldAmount < 9999)
        {
            int overThousand = (int) _goldAmount /1000;
            int overHundret = (int) (_goldAmount -  overThousand * 1000)/100;
            int overTens = (int) (_goldAmount -  overThousand * 1000 -  overHundret*100)/10;
            goldTextUI.text = overThousand.ToString() + "," + overHundret.ToString() + overTens.ToString()+ "K";
        }else if(_goldAmount >= 10000 && _goldAmount < 999999)
        {
            int overThousand = (int) _goldAmount /1000;
            goldTextUI.text = overThousand.ToString() + "K";
        }
        else if(_goldAmount >= 1000000 && _goldAmount < 999999999)
        {
            int overMillion = (int) _goldAmount /1000000;
            goldTextUI.text = overMillion.ToString() + "M";
        }
        else 
        {
            goldTextUI.fontSize = 170;
            goldTextUI.text = "You did it";
        }
    }
}
