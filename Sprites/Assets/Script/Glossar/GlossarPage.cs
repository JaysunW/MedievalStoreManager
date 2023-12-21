using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GlossarPage : MonoBehaviour
{
    private int index;

    public Text headerTx;
    private string header;

    private Sprite sprite;
    public SpriteRenderer spriteRenderer;
    public SpriteRenderer shadowRenderer;
    public Transform spriteTransform;

    public Text descriptionTx;
    private string description;

    private bool found = false;

    public void ChangeTransformForFish()
    {
        spriteTransform.localScale = new Vector3(1.4f,1.4f,1);
        spriteTransform.localRotation = Quaternion.Euler(0,0,90);
    }

    public void ChangeTransformNormal()
    {
        spriteTransform.localScale = new Vector3(2,2,1);
        spriteTransform.localRotation = Quaternion.Euler(0,0,0);
    }

    public void SetIndex(int _index)
    {
        index = _index + 1;
    }

    public void SetSprite(Sprite _gem)
    {
        sprite = _gem;
    }

    public void SetStrings(string _header, string _description)
    {
        header = _header;
        description = _description;
    }

    public void SetBool(bool _found)
    {
        found = _found;
    }

    public void SetValuesOnPage(bool _input)
    {
        if(_input)
        {
            ChangeTransformForFish();
        }else
        {
            ChangeTransformNormal();
        }
        PutValuesIn();
        SetSpriteIn();
    }

    private void PutValuesIn()
    {
        if(!found)
        {
            for(int i = 0; i<header.Length;i++)
            {
                if(!header[i].Equals(' '))
                {
                    header = header.Remove(i,1);
                    header = header.Insert(i,"?");
                }            
            }
            for(int i = 0; i<description.Length;i++ )
            {
                if(!description[i].Equals(' '))
                {
                    
                    description = description.Remove(i,1);
                    description = description.Insert(i,"?");
                }                
            }
        }

        headerTx.text = index.ToString()+". " + header;
        descriptionTx.text = "Description: \n" +description;
    }

    private void SetSpriteIn()
    {
        if(!found)
        {
            spriteRenderer.color = new Color(0,0,0,1);
        }else
        {
            spriteRenderer.color = new Color(1,1,1,1);
        }
        spriteRenderer.sprite = sprite;
        shadowRenderer.sprite = sprite;
    }

}
