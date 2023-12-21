using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BorderSkinChange : MonoBehaviour
{

    private Vector2Int colRow;

    public GridObjectEnum thisObject;
    public bool standardBlockSpriteActive = false;
    public Sprite[] standardBlockSprite;
    public Sprite[] allSidesVariation;

    public void Start()
    {
        GameObject activateBlock = GameObject.FindWithTag("Stats");
        activateBlock.GetComponent<ActivateBlocks>().AddTodeactivatedLists(this.gameObject,GridObjectEnum.MainBorder);
        this.gameObject.active = false;
    }

    public void SetColRow(Vector2Int _vector)
    {
        colRow = _vector;  
        UpdateBlockSprite();
    }

    public void UpdateBlockSprite()
    {
        if(standardBlockSpriteActive)
        {
            string blockSides = GridManagerStats.Instance.WhatSidesAreBlocks((int)colRow.x,(int)colRow.y,thisObject);
            switch(blockSides)
            {
                case "":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[0];
                break;
                case "t":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[8];
                break;
                case "r":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[4];
                break;
                case "d":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[1];
                break;
                case "l":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[3];
                break;
                case "tr":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[12];
                break;
                case "td":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[9];
                break;
                case "tl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[11];
                break;
                case "rd":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[5];
                break;
                case "rl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[7];
                break;
                case "dl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[2];
                break;
                case "trd":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[13];
                break;
                case "trl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[14];
                break;
                case "tdl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[10];
                break;
                case "rdl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[6];
                break;
                case "trdl":
                    this.GetComponent<SpriteRenderer>().sprite = allSidesVariation[Random.Range(0,allSidesVariation.Length)];
                break;
            }
        }
    }
}
