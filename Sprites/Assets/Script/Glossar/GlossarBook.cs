using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GlossarBook : MonoBehaviour
{
    private GemstoneGlossar [] gemstone;
    private ChestGlossar [] chest;
    private FishGlossar [] fish;

    private Glossar [] glossar;

    public int page = 0;

    public GlossarPage leftPage;
    public GlossarPage rightPage;

    public Camera mainCamera;

    public Button nextButton;
    public Button lastButton;

    void Start()
    {
        glossar = GlossarSave.Instance.GetCurrentGlossarArray();
        SetPageWithArrayInfo(page);
        ChangeButton(lastButton, false);
    }

    public void SetPageWithArrayInfo(int _pageCount)
    {
        GlossarPage _page = GivePage(_pageCount);
        _page.SetSprite(glossar[_pageCount].sprite);
        _page.SetIndex(page);
        _page.SetStrings(glossar[_pageCount].name,glossar[_pageCount].description);
        _page.SetBool(glossar[_pageCount].found);
        _page.SetValuesOnPage(glossar[_pageCount].rotate);
    }

    public void SetFishPage(int _pageCount)
    {
        GlossarPage _page = GivePage(_pageCount);
        _page.SetSprite(fish[_pageCount].sprite);
        _page.SetIndex(page);
        _page.SetStrings(fish[_pageCount].name,fish[_pageCount].description);
        _page.SetBool(fish[_pageCount].found);
        _page.SetValuesOnPage(true);
    }

    public void SetGemstonePage(int _pageCount)
    {
        GlossarPage _page = GivePage(_pageCount);
        _page.SetSprite(gemstone[_pageCount].sprite);
        _page.SetIndex(page);
        _page.SetStrings(gemstone[_pageCount].name,gemstone[_pageCount].description);
        _page.SetBool(gemstone[_pageCount].found);
        _page.SetValuesOnPage(false);
    }

    public void SetChestPage(int _pageCount)
    {
        GlossarPage _page = GivePage(_pageCount);
        _page.SetSprite(chest[_pageCount].sprite);
        _page.SetIndex(page);
        _page.SetStrings(chest[_pageCount].name,chest[_pageCount].description);
        _page.SetBool(chest[_pageCount].found);
        _page.SetValuesOnPage(false);
    }

    public GlossarPage GivePage(int _pageCount)
    {
        GlossarPage _output;
        if(_pageCount % 2 == 0)
        {
            _output = leftPage;
        }else
        {
            _output = rightPage;
        }
        return _output;
    }

    public void NextPage()
    {
        StopCoroutine("ChangePage");
        page++;
        SetPageWithArrayInfo(page);
        StartCoroutine("ChangePage");
    }

    public void LastPage()
    {
        StopCoroutine("ChangePage");
        page--;
        SetPageWithArrayInfo(page);
        StartCoroutine("ChangePage");
    }

    private void ChangeButton(Button _button, bool _input)
    {
        _button.interactable = _input;
    }

    private IEnumerator ChangePage()
    {
        ChangeButton(nextButton,false);
        ChangeButton(lastButton, false);
        bool correctSide = false;
        while(!correctSide)
        {
            Vector2 cameraDir = Vector2.zero;

            if(GivePage(page) == leftPage)
            {
                cameraDir = Vector2.left;
            }else
            {
                cameraDir = Vector2.right;
            }
            
            mainCamera.transform.Translate(cameraDir*0.5f);
            if(cameraDir == Vector2.left && mainCamera.transform.position.x <= 0 ||
                cameraDir == Vector2.right && mainCamera.transform.position.x >= 13)
            {
                correctSide=true;
            }
            yield return new WaitForSeconds(0.01f);
        }

        if(page != glossar.Length-1)
            ChangeButton(nextButton,true);
        if(page != 0)
            ChangeButton(lastButton,true);
    }   
}   
