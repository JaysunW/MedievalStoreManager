using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShopChangeTool : MonoBehaviour
{
    public WhatToolIsUsed whatToolScript; 
    public int toolToChangeTo;

    public void ChangeTheTool()
    {
        whatToolScript.ChangeTool(toolToChangeTo);
    }
}
