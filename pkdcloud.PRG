rele mmenu_,_pkdregapi,_pkdgeoloc,_MapItmOpt,_VndrIdDet,_MapItmUp
Public mmenu_,_pkdregapi,_pkdgeoloc,_MapItmOpt,_VndrIdDet,_MapItmUp
_pkdgeoloc = "https://wservices.margcompusoft.com/api/eGeoCoding/GetGeoAddressDetail"
_pkdregapi = "http://10.10.10.31:6010/vendor/vcreate"
_MapItmOpt = "http://10.10.10.31:6010/vendor/GetItemByName"
_VndrIdDet = "http://10.10.10.31:6010/Vendor/getVendorByID/"
_MapItmUp  = "http://10.10.10.31:6010/vendor/vpMapping"

lccompanyid=''
Sele Support
Seek "M"+"PKDUKAAN"+Spac(6)+Str(0,9)+Str(0,9)+Str(1,3)
If Found()
	mremrk=Strconv(Trim(remark),14)
	lccompanyid=strinvalueonpos("|",mremrk,0)
	companystat=strinvalueonpos("|",mremrk,1)
Endif

mmenu_=1
if !empty(lccompanyid) AND companystat='1'
	mmenu_=2
	Sele Support
	Seek 'F'+'PKDUKAAN'+'MAPING'
	If Found()
		mmenu_=3
	endif
endif

*!*	if empty(lccompanyid)
*!*	   mmenu_=1
*!*	else
*!*	   if companystat='1'
*!*	      mmenu_=2
*!*	      Sele Support
*!*	      Seek 'F'+'PKDUKAAN'+'MAPING'
*!*	      If Found()
*!*	         mmenu_=3
*!*	      endif
*!*	   endif
*!*	endif

DO FORM pkdcloud
clea class scrollArea
Define Class scrollArea As Container
	Top=50
	Left=50
	Width=600
	Height=200
	BorderWidth=0
	Visible=.T.
	Add Object ImageScroll1 As Label With ;
		Visible=.T.,width=300,Left=500,backStyle=0,Name='ImageScroll1',;
		caption="Hurry! Get you products Mapped with Pass ki Dukaan."
	Add Object ImageScroll2 As Image With ;
		Visible=.T.,backstyle=0,stretch=1, picture="z:\margvfp\images\add-cart.png",width=39,;
		Left=470,backStyle=0,Name='ImageScroll2'
	Add Object Timerscroller As scrolltimer With Visible=.T.,Interval=25
	Add Object closebtn As CommandButton With ;
		Enabled=.T.,Visible=.T.,Left=0,Top=0,Width=18,Height=18,Caption='X',BackStyle=0,;
		BorderWidth=1,FontBold=.T.,FontSize=8
	Proc closebtn.Click
		This.Parent.Visible= .F.
	Endproc
Enddef
Define Class scrolltimer As Timer
	Procedure Timer
		If This.Parent.Imagescroll1.Left > -500
			This.Parent.Imagescroll1.Left=This.Parent.Imagescroll1.Left-1
		Else
			This.Parent.Imagescroll1.Left=501
		Endif
		If This.Parent.Imagescroll2.Left > -500
			This.Parent.Imagescroll2.Left=This.Parent.Imagescroll2.Left-1
		Else
			This.Parent.Imagescroll2.Left=501
		Endif
	Endproc
Enddef
*serviceresresult=services("POST",APIurl,Strings,"tkn","RestFull",.f.,.t.)

FUNCTION services
	para margautodata1,mrgautdata12,mrgautdat13,mrgautdat14,mrgautdat15,mrgautdat16,mrgautdat17,mrgautdat18,mrgautdat19
	if empty(mrgautdat14)
		mrgautdat14=0 &&token
	endif
	if empty(mrgautdat15)
		mrgautdat15="Clasic"
	endif
	if empty(mrgautdat16)
		mrgautdat16=.f. &&speed
	endif
	if empty(mrgautdat17)
		mrgautdat17=.f.
	endif
	if empty(mrgautdat18)
		mrgautdat18=""
	endif
	if empty(mrgautdat19)
		mrgautdat19=.f.
	endif
	margautodata4=0 &&POST
	do case
		case margautodata1+"  "="MYAPIINTIGRATION1  " or margautodata1+"  "="GET  " &&GET
			mrgautdat1gettype="GET"
			mrgmyurl=mrgautdat13
			margautodata4=1 &&GET
		case margautodata1+"  "="PUT  " or margautodata1+"  "="DELETE  "
			mrgautdat1gettype=margautodata1
			mrgmyurl=mrgautdata12
			mrgpoststring=mrgautdat13
		case margautodata1+"  "="MYAPIINTIGRATION2  " or margautodata1+"  "="POST  " &&POST
			mrgautdat1gettype="POST"
			mrgmyurl=mrgautdata12
			mrgpoststring=mrgautdat13
		otherwise
			mrgautdat1gettype="POST"
			do case
				case margautodata1="LIC_SUPPORT"
					mrgmyurl=margservicesurl+"/MARGSUPPORT.ASMX/"+mrgautdata12
					mrgpoststring=mrgautdat13
				case margautodata1="RETURN_VALUE"
					mrgmyurl=mrgautdata12
					mrgpoststring=mrgautdat13
				case margautodata1="GENERAL_POSTAPI"
					mrgautdat15="RestFull"
					mrgmyurl=margservicewurl+"/api/"+mrgautdata12
					mrgpoststring=mrgautdat13
				case margautodata1="DOWN_DATA"
					mrgpoststring=mrgautdat13
					mrgmyurl=margservicesurl+"/liveorder.asmx/GiveLiveOrderData?WSDL"
				case margautodata1="LIVE_LICWEB"
					mrgmyurl=margservicesurl+"/liveorder.asmx/SoftCategory?WSDL"
					mrgpoststring='Type='+mrgautdata12+'&val='+mrgautdat13
				case margautodata1="LIVE_UP_2020"
					mrgautdat15="RestFull"
					mrgmyurl=margservicewurl+"/api/Distribution/MargDataDistribution"
					mrgpoststring='{"CompanyID":"'+alltrim(str(mrgcompanyid))+'"'
					mrgpoststring=mrgpoststring+',"UID":"'+ltrim(str(tranlvpcode))+"-"+ltrim(str(tranlvvers))+"-"+alltrim(sys(2007,tranlvguid,1,1))+'"'
					mrgpoststring=mrgpoststring+',"Type":"'+mrgautdata12+'"'
					mrgpoststring=mrgpoststring+',"Version":"'+margvers+iif(len(margvertype)=0,"","-"+margvertype)+'"'
					mrgpoststring=mrgpoststring+',"Token":"'+ltrim(str(mrgautdat14))+'"'
					mrgpoststring=mrgpoststring+',"JsonInput":"'+mrgautdat13+'"}'
				case margautodata1="LIVE_UP"
					mrgautdat15="RestFull"
					mrgmyurl=margservicewurl+"/api/eLiveOrder/LiveOrderData"
					mrgpoststring='{"CompanyID":"'+alltrim(str(mrgcompanyid))+'"'
					mrgpoststring=mrgpoststring+',"UID":"'+ltrim(str(tranlvpcode))+"-"+ltrim(str(tranlvvers))+"-"+alltrim(sys(2007,tranlvguid,1,1))+'"'
					mrgpoststring=mrgpoststring+',"Type":"'+mrgautdata12+'"'
					mrgpoststring=mrgpoststring+',"Version":"'+margvers+iif(len(margvertype)=0,"","-"+margvertype)+'"'
					mrgpoststring=mrgpoststring+',"Token":"'+ltrim(str(mrgautdat14))+'"'
					mrgpoststring=mrgpoststring+',"JsonInput":"'+mrgautdat13+'"}'
				case margautodata1="LIVE_CORP"
					mrgautdat15="RestFull"
					mrgmyurl=margservicewurl+"/api/eLiveOrder/LiveOrderData"
					mrgpoststring='{"CompanyID":"0"'
					mrgpoststring=mrgpoststring+',"UID":"'+corproratsyncdid+'"'
					mrgpoststring=mrgpoststring+',"Type":"'+mrgautdata12+'"'
					mrgpoststring=mrgpoststring+',"Version":"'+margvers+iif(len(margvertype)=0,"","-"+margvertype)+'"'
					mrgpoststring=mrgpoststring+',"Token":"'+ltrim(str(mrgautdat14))+'"'
					mrgpoststring=mrgpoststring+',"JsonInput":"'+mrgautdat13+'"}'
				case margautodata1="LIVE_DOWN"
					mrgpoststring=mrgautdat13
					mrgmyurl=margservicesurl+"/liveorder.asmx/"+mrgautdata12+"?WSDL"
				case margautodata1="LIVE_ADMIN"
					mrgpoststring=mrgautdat13
					do case
						case mrgautdata12="AdminRegistration"
							mrgmyurl=margservicesurl+"/liveorder.asmx/AdminRegistration?WSDL"
						case mrgautdata12="CompanyRegistration"
							=seek('F'+'LVOSETUP',"support")
							mrgmyurl=margservicesurl+"/LiveOrder.asmx/CompanyRegistration?WSDL"
							mrgpoststring='Licence='+alltrim(mrglicence)+';'+ltrim(str(fnmfilclus))+';'+corproratsyncdid+'&Branch='+alltrim(mrgbranch)+'&Name='+alltrim(ftpdcrsql(mrgname))+;
								'&Address1='+alltrim(ftpdcrsql(mrgaddress1))+'&Address2='+alltrim(ftpdcrsql(mrgaddress2))+'&Address3='+alltrim(ftpdcrsql(mrgaddress3))+;
								'&Phone='+alltrim(ftpdcrsql(mrgphone))+'&Mobile='+alltrim(ftpdcrsql(mrgmobile))+'&Email='+alltrim(ftpdcrsql(mrgemail))+;
								'&Contact='+alltrim(ftpdcrsql(mrgctpt))+'&Tin='+chrtran(alltrim(comptinno),"|",":")+"|"+chrtran(alltrim(compdlno),"|",":")+;
								'&Condition='+iif(substr(support->remark,3,1)$"YRONX",substr(support->remark,3,1),"N")+; &&Ask Free (1,1) 'N '-View,'Y'-Both,'R'-eRetail,'O'-eOrder,'X'-No
							substr(support->remark,14,1)+; &&Order allowed beyond Stock (2,1)
							substr(support->remark,22,4)+; &&Minimum Order for Registered (3,4)
							substr(support->remark,26,4)+; &&Minimum Order for Un-Registered (7,4)
							substr(support->remark,30,4)+; &&Show Stock XXX+ in Customer App, if stock> (11,4)
							substr(support->remark,34,3)+; &&Show Stock XX+ in Customer App, if stock< & #0 (15,3)
							substr(support->remark,38,3)+; &&Charges for Minimum Order  (18,3)
							iif(mrgtype="M","2",iif(mrgtype="R","1","0"))+; &&Manufactur/Retailer/Distributor  (21,1)
							substr(support->remark,42,1)+; &&Un-Registered Customers Allowed  (22,1)
							substr(support->remark,43,5)+; &&eRetail additional Discount  (23,5)
							iif(substr(setup_mf7,6,1)$"YSqB",iif(upper(finalcpmrp)="SIZE","M","Y"),"N")+; &&eRetail Batch/Size wise ORder (28,1)
							iif(substr(support->remark,51,1)="U","U","A")+; &&Stock Show to Registered / Both  (29,1)
							iif(subs(ctrllvsetup,48,1)$"NYB",subs(ctrllvsetup,48,1),iif(companystat=12 or substr(setup_mf5,59,1)$"YC","B","Y"))+; &&Show Stock in App's (30,1)
							substr(ctrllvsetup,56,1)+; &&Show Rates & Deal to Unregistered (31,1)
							substr(ctrllvsetup,58,1)+; &&Show All Rates to Salesman (32,1)
							substr(ctrllvsetup,59,3)+; &&Fix Charges for HIGH PRIORITY (33,3)
							iif(substr(ctrllvsetup,62,1)$"ABCD",substr(ctrllvsetup,62,1),"A")+; &&Default Rates for Un-Registered Customers (36,1)
							iif(substr(ctrllvsetup,64,1)$"23",substr(ctrllvsetup,64,1),"N")+; &&Order Quantity allowed in Decimal (37,1)
							iif(substr(ctrllvsetup,65,1)$"YNB",substr(ctrllvsetup,65,1),"B")+; &&Show Stock in eRetail App's - Unregistered User (38,1)
							substr(setfr_mf11,41,1)+; &&YB-Drug FB-Food C-Company Wise Licence (39,1)
							substr(setfr_mf11,43,1) &&YB-Drug FB-Food Item Wise Licence (40,1)
							if seek("M"+"SURVEYED"+"000001","support")
								mrgpoststring=mrgpoststring+padr(support->heading,25)+padr(support->remark,80) &&Timing & Trade (41,105)
							else
								do case
									case multimfg=space(2)+"ÿ"+space(1)+"ÿ"+space(2)+"ÿ"+space(2)
										busbase=1
									case companystat=12
										busbase=iif(substr(setup_mf5,59,1)="Y",4,3)
									otherwise
										if substr(setup_smf4,32,1)="N"
											busbase=3
										else
											if substr(setup_mf5,59,1)="Y"
												busbase=4
											else
												busbase=2
											endif
										endif
								endcase
								do case
									case finalcpmrp="Batch" and finalcp21#chr(78)
										bustype=1
									case finalcpmrp="MRP" and finalcp21#chr(78)
										bustype=5
									otherwise
										do case
											case companystat=12 or companystat=14 or companystat=7
												bustype=1
											case companystat=5 or companystat=14
												bustype=5
											case companystat=29 or companystat=16
												bustype=3
											case companystat=22
												bustype=7
											case companystat=15
												bustype=2
											otherwise
												bustype=8
										endcase
								endcase
								mrgpoststring=mrgpoststring+padr(str(busbase,1)+str(bustype,2)+"1 09:00 A07:00 PPHA",25)+;
									padr("09:00 A12:00 P12:00 P04:00 P04:00 P09:00 P1111111",80)
							endif
							mrgpoststring=mrgpoststring+'&bstatus='+mrgabilstat+'|'+ltrim(str(mrgcompanyid))+'|'+trim(mrgreglat)+'|'+trim(mrgreglong)+'|'+trim(mrgregpin)+'|'+; &&Status+CompanyID+Lat+Long+Pincode
							converinchr(alltrim(mrgsmsstrg))+'|'+chrtran(alltrim(mrgsmsdefa),"|",":")+'|'+; &&message string+default message
							alltrim(substr(setup_mf5,21,4))+'|'+chrtran(alltrim(substr(setfr_mc15,1,3)),"|",":")+'|'+; &&tax heading+curreancy symbol
							chrtran(alltrim(mrgrefferal),"|",":")+'|' &&Refferal code
							=seek('F'+'LVOSETUP',"support")
					endcase
				case margautodata1="MYOWN_eLiveOrder_"
					mrgautdat15="RestFull"
					mrgmyurl=margservicewurl+"/api/eLiveOrder/"+substr(margautodata1,18)
					mrgpoststring=mrgautdat13
				otherwise
					mrgpoststring=mrgautdat13
					do case
						case mrgautdata12="MargAutoUploadData"
							mrgmyurl=margservicesurl+"/liveorder.asmx/MargAutoUploadData?WSDL"
							mrgpoststring='Licence='+reg_comv_4+'&'+'Branch='+finalcp25+'&'+'Type='+margautodata1+'&'+'Remark='+mrgautdat13
						case mrgautdata12="AddCustomerToCompany"
							mrgmyurl=margservicesurl+"/LiveOrder.asmx/AddCustomerToCompany?WSDL"
					endcase
			endcase
	endcase
	serviceresresmsg=""
	serviceresresult=""
	margsmssendtime=datetime ()
	if margautodata4=1
		try
			mrgpostohttp=mrgxmlhtp(mrghttpget,1)
			if mrgautdat16=.t.
				mrgpostohttp.settimeouts(1500,1500,2500,2500)
			else
				mrgpostohttp.settimeouts(30000, 30000, 30000, 30000) &&website find,Conection,send request,receive timout
			endif
			mrgpostohttp.open("GET",mrgmyurl)
			mrgpostohttp.option(4)=13056
			if at(":",mrgautdat15)>0
				do while len(alltrim(mrgautdat15))#0
					if at("|",mrgautdat15)>0
						mrgautdattot=substr(mrgautdat15,1,at("|",mrgautdat15)-1)
						mrgautdat15=substr(mrgautdat15,at("|",mrgautdat15)+1)
					else
						mrgautdattot=trim(mrgautdat15)
						mrgautdat15=""
					endif
					if len(alltrim(mrgautdattot))>0 and len(trim(substr(mrgautdattot,1,at(":",mrgautdattot)-1)))>0 and len(substr(mrgautdattot,at(":",mrgautdattot)+1))>0
						mrgpostohttp.setrequestheader(trim(substr(mrgautdattot,1,at(":",mrgautdattot)-1)),substr(mrgautdattot,at(":",mrgautdattot)+1))
					endif
				enddo
			endif
			mrgpostohttp.send()
			if mrgautdat19=.t.
				serviceresresult=mrgpostohttp.responsebody
			else
				serviceresresult=mrgpostohttp.responsetext
			endif
		catch to oerr
			mrgpostohttp=0
			serviceresresult="ERROR:"+trim(oerr.message)
		endtry
	else
		try
			mrgpostohttp=mrgxmlhtp(mrghttpget,1)
			if mrgautdat16=.t.
				mrgpostohttp.settimeouts(1500,1500,2500,2500)
			else
				mrgpostohttp.settimeouts(30000, 30000, 30000, 30000) &&website find,Conection,send request,receive timout
			endif
			mrgpostohttp.open("POST",mrgmyurl,.f.)
			mrgpostohttp.option(4)=13056
			if at(":",mrgautdat15)>0
				do while len(alltrim(mrgautdat15))#0
					if at("|",mrgautdat15)>0
						mrgautdattot=substr(mrgautdat15,1,at("|",mrgautdat15)-1)
						mrgautdat15=substr(mrgautdat15,at("|",mrgautdat15)+1)
					else
						mrgautdattot=trim(mrgautdat15)
						mrgautdat15=""
					endif
					if len(alltrim(mrgautdattot))>0 and len(trim(substr(mrgautdattot,1,at(":",mrgautdattot)-1)))>0 and len(substr(mrgautdattot,at(":",mrgautdattot)+1))>0
						mrgpostohttp.setrequestheader(trim(substr(mrgautdattot,1,at(":",mrgautdattot)-1)),substr(mrgautdattot,at(":",mrgautdattot)+1))
					endif
				enddo
			else
				if upper(mrgautdat15)="REST" &&"RestFull"
					mrgpostohttp.setrequestheader('Content-Type','application/json')
				else
					mrgpostohttp.setrequestheader('Content-Type','application/x-www-form-urlencoded')
				endif
			endif
			if len(mrgautdat18)>0
				mrgpostohttp.setclientcertificate(mrgautdat18)
			endif
			mrgpostohttp.send(mrgpoststring)
			=mrgpostohttp.getallresponseheaders()
			if mrgautdat19=.t.
				serviceresresult=mrgpostohttp.responsebody
			else
				serviceresresult=mrgpostohttp.responsetext
			endif
		catch to oerr
			mrgpostohttp=0
			serviceresresult="ERROR:"+trim(oerr.message)
		endtry
	endif
	if upper(serviceresresult)="ERROR:" or at("HTTP 404",upper(serviceresresult))>0 or at(upper("[HttpException]"),upper(serviceresresult))>0
		if ma_sh_er="Y" and ;
				(file(chr(65)+chr(67)+chr(84)+chr(73)+chr(86)+chr(69)+chr(76)+chr(79)+chr(67)+chr(65)+chr(76)+chr(83)+chr(69)+chr(82)+chr(86)+chr(73)+chr(67)+chr(69)+chr(83)+chr(80)+chr(82)+chr(69)+chr(46)+chr(84)+chr(88)+chr(84))=.t. or ;
				file(chr(65)+chr(67)+chr(84)+chr(73)+chr(86)+chr(69)+chr(76)+chr(79)+chr(67)+chr(65)+chr(76)+chr(83)+chr(69)+chr(82)+chr(86)+chr(73)+chr(67)+chr(69)+chr(83)+chr(85)+chr(65)+chr(84)+chr(46)+chr(84)+chr(88)+chr(84))=.t.)
			service_myfile=fcreate("services_"+sys(3)+".err")
			=fwrite(service_myfile,mrgmyurl+chr(13)+mrgpoststring+chr(13)+chr(13)+serviceresresmsg)
			=fclose(service_myfile)
		endif
		=margmsg(serviceresresmsg)
		serviceresresmsg=substr(substr(serviceresresult,1,at(";",serviceresresult)-1),13)
		serviceresresult=""
	else
		do case
			case upper(serviceresresult)="MARGMESSAGE:"
				serviceresresmsg=substr(substr(serviceresresult,1,at(";",serviceresresult)-1),13)
				serviceresresult=substr(serviceresresult,at(";",serviceresresult)+1)
			case upper(serviceresresult)#"SUCESS" and at("MISSING PARAMETER",upper(serviceresresult))>0
				serviceresresmsg="Parameter Missing, Please Update your Software...."
				serviceresresult=""
		endcase
		if fmtlautosnd#"@" and (datetime ()-margsmssendtime)>iif(developmentkit=chr(89) or ma_sh_er="Y",10,30)
			=margmsg("Taking to much time in Sending Data !")
		else
			if ma_sh_er#"Y" and mrgautdat17=.f.
				wait clear
			endif
		endif
	endif
	myresponseresult=serviceresresult
	retu serviceresresult

proc testexeconnection
	vgn=1
	do while vgn<=8
		=testexeconnection2(vgn)
		vgn=vgn+1
	enddo

proc testexeconnection2
	para testexeconnection2
	do case
		case testexeconnection2=1
			testexeconnval="WinHttp.WinHttpRequest.5.1"
		case testexeconnection2=2
			testexeconnval="msxml2.xmlhttp.6.0"
		case testexeconnection2=3
			testexeconnval="msxml2.xmlhttp.5.0"
		case testexeconnection2=4
			testexeconnval="msxml2.xmlhttp.4.0"
		case testexeconnection2=5
			testexeconnval="msxml2.xmlhttp.3.0"
		case testexeconnection2=6
			testexeconnval="msxml2.xmlhttp.2.0"
		case testexeconnection2=7
			testexeconnval="msxml2.xmlhttp.1.0"
		case testexeconnection2=8
			testexeconnval="msxml2.xmlhttp"
	endcase
	testexeerror=""
	try
		mrgpostohttp=createobject(testexeconnval)
		mrgpostochk=.t.
	catch to err
		testexeerror=testexeerror+"Connection "+testexeconnval+" Fail !"+chr(13)+err.message+chr(13)+chr(13)
		mrgpostohttp=0
		mrgpostochk=.f.
	endtry
	try
		mrgpostohttp.settimeouts(30000,30000,30000,30000)
	catch to err
		testexeerror=testexeerror+"Connection Timeout Fail !"+chr(13)+err.message+chr(13)+chr(13)
	endtry
	try
		mrgpostohttp.open("POST",margservicesurl+"/liveorder.asmx/GiveLiveOrderData?WSDL")
	catch to err
		testexeerror=testexeerror+"Connection Open Fail !"+chr(13)+err.message+chr(13)+chr(13)
	endtry
	try
		mrgpostohttp.option(4)=13056
	catch to err
		testexeerror=testexeerror+"Connection Open Fail !"+chr(13)+err.message+chr(13)+chr(13)
	endtry
	try
		mrgpostohttp.setrequestheader('Content-Type','application/x-www-form-urlencoded')
	catch to err
		testexeerror=testexeerror+"Connection Content-Type Fail !"+chr(13)+err.message+chr(13)+chr(13)
	endtry
	try
		mrgpostohttp.send("FileName=Check0000"+"&CompanyID=0")
	catch to err
		testexeerror=testexeerror+"Connection Send Fail !"+chr(13)+err.message+chr(13)+chr(13)
	endtry
	try
		serviceresresult=mrgpostohttp.responsetext
	catch to err
		testexeerror=testexeerror+"Connection Send Fail !"+chr(13)+err.message+chr(13)+chr(13)
		serviceresresult=""
	endtry
	serviceresresult=strinvalueonpos("|",serviceresresult,0)
	if ctod ( "^"+substr(serviceresresult,1,4)+dateformhsl+substr(serviceresresult,5,2)+dateformhsl+substr(serviceresresult,7,2) )#ctod("")
		if margmessage("Response "+testexeconnval+" !","PASS !"+chr(13)+chr(13)+"Want to check others ?","OK","Default,Check "+ltrim(str(testexeconnection2+1)))=1
			lrefcntselect=select()
			sele select(1)
			=openautoupdate()
			if used("autoupdate")
				sele autoupdate
				go top
				loca for upper(name)="SERVICE-CONNECTION-OBJECT"
				if !found()
					=margappend()
					repl name with "SERVICE-CONNECTION-OBJECT"
				endif
				repl message with testexeconnval
				use
			endif
			sele (lrefcntselect)
			vgn=vgn+100
		endif
	else
		if margmessage("Response "+testexeconnval+" !",testexeerror+chr(13)+chr(13)+serviceresresult,"X2","OK,?")=2
			=margshell("https://www.google.com/search?&q="+msgunicode(nmwoswonzn(testexeerror,1),"2","2"))
		endif
	endif
	*: EOF: SERVICES.PRG < COPYRIGHT REG. NO. 20938 => MARG ERP LIMITED, MARG TOWER, PLOT NO.7, WAZIRPUR PRESS AREA, DELHI-110035 (INDIA) >