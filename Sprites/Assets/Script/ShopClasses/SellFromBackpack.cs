using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SellFromBackpack : MonoBehaviour
{
    public Button sellButton;
    public Button intoTheWater;
    public Button glossar;
    public GameObject soldThingSpriteRendererGem;
    public GameObject soldThingSpriteRendererFish;
    public GameObject textObject;
    private bool selling;

    public void Start()
    {
        soldThingSpriteRendererGem.active = false;
        soldThingSpriteRendererFish.active = false;
        textObject.active = false;
        textObject.GetComponent<Text>().color = new Vector4(1,1,1,0);
        if(PlayerBackpack.Instance.IsBackpackEmpty())
            sellButton.interactable = false;
    }

    public void SellAll()
    {
        StartCoroutine("SellAllObjects");
    }

    private void ChangeAllImportantButtons(bool _input)
    {
        intoTheWater.interactable = _input;
        glossar.interactable = _input;
    }

    IEnumerator SellAllObjects()
    {
        ChangeAllImportantButtons(false);
        sellButton.interactable = false;
        soldThingSpriteRendererGem.active = true;
        textObject.active = true;

        List<Gemstones> gemBag = PlayerBackpack.Instance.GetGemBackpack();
        List<Gemstones> jewelBag = PlayerBackpack.Instance.GetJewelBackpack();
        List<Fish> smallFishBag = PlayerBackpack.Instance.GetSmallFishBackpack();
        List<Fish> mediumFishBag = PlayerBackpack.Instance.GetMediumFishBackpack();
        List<Fish> bigFishBag = PlayerBackpack.Instance.GetBigFishBackpack();

        soldThingSpriteRendererGem.GetComponent<Image>().color = new Vector4(1,1,1,1);
        textObject.GetComponent<Text>().color = new Vector4(0,0,0,1);

        foreach(Gemstones gem in gemBag)
        {
            soldThingSpriteRendererGem.GetComponent<Image>().sprite = gem.sprite;
            PlayerStats.Instance.AddGold(gem.value);
            yield return new WaitForSeconds(0.2f);
        }

        foreach(Gemstones jewel in jewelBag)
        {
            soldThingSpriteRendererGem.GetComponent<Image>().sprite = jewel.sprite;
            PlayerStats.Instance.AddGold(jewel.value);
            yield return new WaitForSeconds(0.2f);
        }

        soldThingSpriteRendererGem.active = false;
        soldThingSpriteRendererFish.GetComponent<Image>().color = new Vector4(1,1,1,1);
        soldThingSpriteRendererFish.active = true;

        foreach(Fish fish in smallFishBag)
        {
            soldThingSpriteRendererFish.GetComponent<Image>().sprite = fish.sprite;
            PlayerStats.Instance.AddGold(fish.value);
            yield return new WaitForSeconds(0.2f);
        }

        foreach(Fish fish in mediumFishBag)
        {
            soldThingSpriteRendererFish.GetComponent<Image>().sprite = fish.sprite;
            PlayerStats.Instance.AddGold(fish.value);
            yield return new WaitForSeconds(0.2f);
        }

        foreach(Fish fish in bigFishBag)
        {
            soldThingSpriteRendererFish.GetComponent<Image>().sprite = fish.sprite;
            PlayerStats.Instance.AddGold(fish.value);
            yield return new WaitForSeconds(0.2f);
        }

        selling = false;
        textObject.GetComponent<Text>().color = new Vector4(0,0,0,0);

        soldThingSpriteRendererFish.active = false;
        textObject.active = false;
        
        PlayerBackpack.Instance.ClearBackpack();
        ChangeAllImportantButtons(true);
    }   
}
