using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipWreckSkin : MonoBehaviour
{
    public Sprite [] wreck;

    private Vector2 colRow;

    public SpriteRenderer spriteRenderer;

    private void Start()
    {
        spriteRenderer.sprite = RandomSpriteRender();
    }

    private Sprite RandomSpriteRender()
    {
        Sprite _outputSprite = null;

            int _wreckChance = (int) Random.Range(0,wreck.Length);

            _outputSprite = wreck[_wreckChance];


        return _outputSprite;
    }

    public void PutInfosIntoPrefab(Vector2 _colRow)
    {
        colRow = _colRow;

    }

    public bool ChanceInAHundred(float _chanceToHit)
    {
        float _objectChance = Random.Range(0,100f);
        if(_objectChance < _chanceToHit){
            return true;
        }
        return false;
    }
}
