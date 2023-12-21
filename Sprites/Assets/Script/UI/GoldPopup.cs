using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GoldPopup : MonoBehaviour
{
    private int goldAmount;

    public Text text;
    public Rigidbody2D rig2D;

    public void SetPosition(Vector2 _position)
    {
        this.transform.position = _position;
    }

    public void SetColor(Color _colorInput)
    {
        text.color = _colorInput;
    }

    public void SetVelocity(Vector2 _vec2)
    {
        rig2D.velocity = _vec2;
    }

    public void SetAmount(int _amount)
    {
        goldAmount = _amount;
        text.text = goldAmount.ToString();
        Destroy(this.gameObject,1.5f);
    }

}
