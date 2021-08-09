$(document).ready(initial);
var defaultArray = [0,0,1];
var objArray = new Array();
var titArray = new Array();
var headHgt = 0 ,  svalue ="" , tmpText = "";
function initial ()
{
	screenSetting();
	defaultSetting();
	$(document).on('resize',screenSetting);
	$(window).on( "orientationchange", function( event ) {
		rotationChange();
	});
	$(window).on('resize', function( event ) {
		screenSetting();
		rotationChange();
	});
}

function defaultSetting()
{
	objArray.push($('.mStage .frame')[0]);
	objArray.push($('.mStage .b1')[0]);	
	objArray.push($('.mStage .mTitle')[0]);	
	objArray.push($('.mStage .backbutton')[0]);	
	$(objArray[0]).css('width',defaultArray[0]);
	var _mView = $('.mStage .view')[0];
	var _hBtn = $('.mStage .homebutton')[0];
	$(_mView).css('width',defaultArray[0]);
	$($('.mStage')).css('width',"100%");
	$(objArray[1]).on('click',venishPage);
	$(_hBtn ).on('click',getHome);
}

//回到身份類別頁面
function getHome()
{
	var _views =  $(objArray[0]).find('.view');
	$(objArray[0]).animate({'left':0},1000,function()
	{
		for(var i = 1 ; i < _views.length ; i++)
		{
			$(_views[i]).remove();
			titArray.pop();
		}	
		$(objArray[3]).animate({'opacity':0},500,function(){$(objArray[2]).text();});
		$(objArray[2]).animate({'opacity':0,'right':70},500,function(){
			$(objArray[2]).text(titArray[0]);
			$(objArray[2]).animate({'opacity':1,'right':0},500);
			defaultArray[2] = 1;
		});
	});
}

//更換上下左右視窗
function rotationChange()
{
	var _mStage = $(objArray[0]).parents('div.mStage')[0] , i = 0 , _views = $(objArray[0]).find('.view');
	$(_mStage).css({'width':'100%','height':defaultArray[1] + headHgt});
	$(objArray[0]).css({'width':defaultArray[0] * _views.length ,'height':defaultArray[1]});
	$(objArray[0]).animate({'left' : -(defaultArray[0] * (_views.length - 1))},500);
	for(; i < _views.length ; i++)
	{
		var _cts = $(_views[i]).find('div.mField')[0];
		$(_views[i]).css('width',defaultArray[0]);
	}
}

function firstLoad(_url , _arg01 , _arg02 , _arg03, _arg04)
{
	var _mView = $('.mStage .view')[0];
	getData3(_mView , _url , _arg01 , _arg02 , _arg03 ,_arg04);
}

//畫面尺寸設定
function screenSetting()
{
	var _mHeader = $('.mHeader')[0];
	headHgt = fetchHeight(_mHeader);
	defaultArray[0] = $(window).width();
	if(navigator.userAgent.match(/Android/i))
	{
		defaultArray[1] = $(window).height() - headHgt - 5;
	}else{
		defaultArray[1] = $(window).height() - 100;
	}
}

//回上一頁，並刪原頁
function venishPage()
{
	if(titArray.length > 2)
	{
		defaultArray[2]--;
		titArray.pop();
		var _views = $(objArray[0]).find('div.view');
		//var _iframe = $(_views[_views.length - 1]).find('iframe');
		$(objArray[0]).animate({'left':parseInt($(objArray[0]).css('left')) + defaultArray[0]},500,function(){
			$(_views[_views.length - 1]).remove();	
		});
		$(objArray[2]).animate({'opacity':0,'right':70},500,function(){
						//$(objArray[2]).text(titArray[defaultArray[2]]);
						$(objArray[2]).text(titArray[titArray.length - 1]);
						$(objArray[2]).animate({'opacity':1,'right':0},500);
					});
					
		btnChange(titArray[titArray.length - 2]);
	}else{
		//返回主畫面
		defaultArray[2]--;
		titArray.pop();
		var _views = $(objArray[0]).find('div.view');
		//var _iframe = $(_views[_views.length - 1]).find('iframe');
		$(objArray[0]).animate({'left':parseInt($(objArray[0]).css('left')) + defaultArray[0]},500,function(){
			$(_views[_views.length - 1]).remove();	
		});
		$(objArray[2]).animate({'opacity':0,'right':70},500,function(){
						$(objArray[2]).text(titArray[titArray.length - 1]);
						$(objArray[2]).animate({'opacity':1,'right':0},500);
					});
		$(objArray[3]).animate({'margin-left':-($(objArray[3]).width() + 22),'opacity':0},500,function(){$(objArray[2]).text();});
	}
}

//更換按鈕文字
function btnChange(_nName)
{
	var _btn = $(objArray[1]).parents('div.backbutton')[0];
	$(_btn).stop();
	$(_btn).animate({'margin-left':-($(_btn).width() + 22),'opacity':0} , 500 , function(){
		$(objArray[1]).text(_nName);
		$(_btn).delay(100).animate({'margin-left':'5px','opacity':1},500);
	});
}

function createObj(_type , _name)
{
	var _obj = document.createElement(_type);
	if(_name!==false)
	{
		_obj.className = _name;	
	}
	return _obj
}

function changeStat(_obj)
{
	var _mFrame = $(_obj).parents('div.mField')[0];
	var _prt = $(_obj).parents('div')[0] , _chsNum = 0;
	var _li = $(_prt).find('li') , _div = $(_mFrame).find('.contents .cont');
	for(var i = 0 ; i < _li.length; i ++)
	{
		if(_li[i] == _obj)
		{
			_chsNum = i;
			_li[i].className = "act";
			_div[i].className = "cont act";	
		}else{
			_li[i].className = "nor";
			_div[i].className = "cont nor";
		}
	}
}

function RetrievePage(_lnk , _arg01 , _arg02 , _arg03, _arg04, _arg05, _arg06, _arg07, _arg08)
{
	//可用來在存檔後，刷新頁面(contents)
	var _newView = $(objArray[0]).find('.view')[defaultArray[2]-1];
	var _conFrame = $(_newView).find('.contents')[0];

	_newView.className += " loading";
	$(_conFrame).empty();
	var _iFrame = createObj('div','mframe');
	$(_newView).css('width',defaultArray[0]);
	getData5(_iFrame , _lnk  , _arg01 , _arg02 , _arg03 , _arg04, _arg05, _arg06, _arg07, _arg08 , function() {
	
		$(_conFrame).animate({'opacity':0} , 500 , function(){
			_newView.className = "view";
			var _conts = $(_iFrame).find('.contents')[0];
			$(_conFrame).append(_conts);
			$(_conFrame).animate({'opacity':1} , 500);

		});
	});
}
function getData5(_frame , _url  , _arg01 , _arg02 , _arg03 , _arg04, _arg05, _arg06, _arg07, _arg08,_fnc)
{
	var _prtFrame = $(_frame).parent('div')[0];
	
	$(_frame).css({'display':'none','opacity':0});
	$.ajax({
		type: "get",
		url: _url,
		data: {arg01: _arg01 , arg02: _arg02 , arg03: _arg03 , arg04: _arg04, arg05: _arg05, arg06: _arg06, arg07: _arg07, arg08: _arg08},
		datatype: "json",
		contentType: "application/json;charset=utf-8",
		success: function(result)
		{
			$(_frame).append(result);
			if(_fnc !== false)
			{
				_fnc();
			}
		}
	});
}
function fetchHeight(_obj)
{
	var _hgt = $(_obj).height() + parseInt($(_obj).css("padding-top")) + parseInt($(_obj).css("padding-bottom")) + parseInt($(_obj).css("margin-top")) + parseInt($(_obj).css("margin-bottom"));
	return _hgt;
}