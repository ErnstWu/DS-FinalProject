PROC SQL; 
	SELECT COUNT(DISTINCT USER_ID), COUNT(*) FROM SESSIONS; 
	SELECT COUNT(DISTINCT ID), COUNT(*) FROM TRAIN_USERS; 
QUIT;

PROC SQL; 
	SELECT COUNT(*) FROM TRAIN_USERS
		WHERE ID IN (SELECT DISTINCT USER_ID FROM SESSIONS); 
QUIT;


/******************************************************************************************************************************************/
/* EDA on Training Data */
/******************************************************************************************************************************************/

/*variable analysis in training dataset*/
PROC FREQ DATA=TRAIN_USERS; 
	TABLE GENDER SIGNUP_METHOD LANGUAGE AFFILIATE_CHANNEL AFFILIATE_PROVIDER SIGNUP_APP FIRST_DEVICE_TYPE FIRST_BROWSER
		COUNTRY_DESTINATION/MISSING; 
RUN;

/*gender*/
PROC FREQ DATA=TRAIN_USERS; 
	TABLE GENDER*COUNTRY_DESTINATION/NOFREQ NOPERCENT NOROW MISSING CHISQ; 
RUN;

DATA ModelDst; 
	SET TRAIN_USERS; 
	IF STRIP(gender)="-unknown-" OR STRIP(gender)="OTHER" THEN gender="unknown";
RUN;

PROC FREQ DATA=ModelDst; TABLE GENDER; RUN;

DATA ModelDst(DROP=gender); 
	SET ModelDst; 
	IF gender="FEMALE" THEN Gender_F=1; ELSE Gender_F=0; 
	IF gender="MALE" THEN Gender_M=1; ELSE Gender_M=0; 
	IF gender="unknown" THEN Gender_U=1; ELSE Gender_U=0; 
RUN;

/*SIGNUP METHOD*/
PROC FREQ DATA=ModelDst; 
	TABLE SIGNUP_METHOD*COUNTRY_DESTINATION/ NOPERCENT NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=signup_method); 
	SET ModelDst; 
	IF signup_method="basic" THEN Signup_Basic=1; ELSE Signup_Basic=0; 
	IF signup_method="facebook" THEN Signup_Fb=1; ELSE Signup_Fb=0; 
RUN;

/*LANGUAGE*/
PROC FREQ DATA=TRAIN_USERS; 
	TABLE LANGUAGE*COUNTRY_DESTINATION/NOFREQ NOPERCENT NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=LANGUAGE); 
	SET ModelDst; 
	IF LANGUAGE="en" THEN Language_En=1; ELSE Language_En=0; 
RUN;

/*AFFILIATE_CHANNEL*/
PROC FREQ DATA=ModelDst; 
	TABLE AFFILIATE_CHANNEL*COUNTRY_DESTINATION/NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=AFFILIATE_CHANNEL); 
	SET ModelDst; 
	IF AFFILIATE_CHANNEL="direct" THEN Channel_Direct=1; ELSE Channel_Direct=0; 
	IF AFFILIATE_CHANNEL="sem-brand" THEN Channel_SemB=1; ELSE Channel_SemB=0;
	IF AFFILIATE_CHANNEL="sem-non-brand" THEN Channel_SemNB=1; ELSE Channel_SemNB=0;
	IF AFFILIATE_CHANNEL="seo" THEN Channel_Seo=1; ELSE Channel_Seo=0;
	IF AFFILIATE_CHANNEL="api" THEN Channel_Api=1; ELSE Channel_Api=0;
	IF AFFILIATE_CHANNEL="content" THEN Channel_Content=1; ELSE Channel_Content=0;
	IF AFFILIATE_CHANNEL="other" THEN Channel_Other=1; ELSE Channel_Other=0;
RUN;

/*AFFILIATE_PROVIDER*/
PROC FREQ DATA=ModelDst; 
	TABLE AFFILIATE_PROVIDER*COUNTRY_DESTINATION/NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=AFFILIATE_PROVIDER); 
	SET ModelDst; 
	IF AFFILIATE_PROVIDER="direct" THEN Provider_Direct=1; ELSE Provider_Direct=0; 
	IF AFFILIATE_PROVIDER="google" THEN Provider_Google=1; ELSE Provider_Google=0;
	IF AFFILIATE_PROVIDER="other"  THEN Provider_Other=1; ELSE Provider_Other=0;
RUN;

/*SIGNUP_APP*/
PROC FREQ DATA=ModelDst; 
	TABLE SIGNUP_APP*COUNTRY_DESTINATION/NOFREQ NOPERCENT NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=SIGNUP_APP); 
	SET ModelDst; 
	IF SIGNUP_APP="Android" THEN SignupApp_Android=1; ELSE SignupApp_Android=0; 
	IF SIGNUP_APP="Web" THEN SignupApp_Web=1; ELSE SignupApp_Web=0;
	IF SIGNUP_APP="iOS"  THEN SignupApp_iOS=1; ELSE SignupApp_iOS=0;
RUN;

/*FIRST_DEVICE_TYPE*/
PROC FREQ DATA=ModelDst; 
	TABLE FIRST_DEVICE_TYPE*COUNTRY_DESTINATION/NOPERCENT NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=FIRST_DEVICE_TYPE); 
	SET ModelDst; 
	IF FIRST_DEVICE_TYPE in ("Android Tablet" "Android Phone") THEN FirstDev_AndroidM=1; ELSE FirstDev_AndroidM=0; 
	IF FIRST_DEVICE_TYPE in ("Mac Desktop" "iPad" "iPhone") Then FirstDev_Apple=1; ELSE FirstDev_Apple=0; 
	IF FIRST_DEVICE_TYPE="Mac Desktop" Then FirstDev_Mac=1; ELSE FirstDev_Mac=0;
	IF FIRST_DEVICE_TYPE="iPad" Then FirstDev_iPad=1; ELSE FirstDev_iPad=0;
	IF FIRST_DEVICE_TYPE="iPhone" Then FirstDev_iPhone=1; ELSE FirstDev_iPhone=0;
	IF FIRST_DEVICE_TYPE="Windows Desktop" Then FirstDev_Win=1; ELSE FirstDev_Win=0;
	IF FIRST_DEVICE_TYPE="Desktop (Other)" Then FirstDev_OtherDesktop=1; ELSE FirstDev_OtherDesktop=0; 
	IF FIRST_DEVICE_TYPE="Other/Unknown" Then FirstDev_Unknown=1; ELSE FirstDev_Unknown=0; 
RUN;

/*FIRST_BROWSER*/
PROC FREQ DATA=ModelDst; 
	TABLE FIRST_BROWSER/MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=FIRST_BROWSER); 
	SET ModelDst; 
	IF FIRST_BROWSER="-unknown-" THEN FirstBrowser_Unknown=1; ELSE FirstBrowser_Unknown=0; 
	IF FIRST_BROWSER="Chrome" THEN FirstBrowser_Chrome=1; ELSE FirstBrowser_Chrome=0;
	IF FIRST_BROWSER="Firefox" THEN FirstBrowser_Firefox=1; ELSE FirstBrowser_Firefox=0;
	IF FIRST_BROWSER="IE" THEN FirstBrowser_IE=1; ELSE FirstBrowser_IE=0;
	IF FIRST_BROWSER="Mobile Safari" THEN FirstBrowser_MSafari=1; ELSE FirstBrowser_MSafari=0;
	IF FIRST_BROWSER="Safari" THEN FirstBrowser_Safari=1; ELSE FirstBrowser_Safari=0;
RUN;

PROC CONTENTS DATA=ModelDst; RUN;

PROC FREQ DATA=ModelDst; 
	TABLE first_affiliate_tracked*COUNTRY_DESTINATION/NOPERCENT NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=first_affiliate_tracked); 
	SET ModelDst; 
	IF first_affiliate_tracked="linked" THEN Tracked_linked=1; ELSE Tracked_linked=0; 
	IF first_affiliate_tracked="omg" THEN Tracked_omg=1; ELSE Tracked_omg=0;
	IF first_affiliate_tracked="tracked-other" THEN Tracked_other=1; ELSE Tracked_other=0;
	IF first_affiliate_tracked="untracked" THEN Untracked=1; ELSE Untracked=0;
RUN;

PROC FREQ DATA=ModelDst; 
	TABLE signup_flow*COUNTRY_DESTINATION/NOROW MISSING CHISQ; 
RUN;

DATA ModelDst(DROP=signup_flow); 
	SET ModelDst; 
	IF signup_flow=0 THEN Flow_0=1; ELSE Flow_0=0; 
	IF signup_flow=2 THEN Flow_2=1; ELSE Flow_2=0;
	IF signup_flow=3 THEN Flow_3=1; ELSE Flow_3=0;
	IF signup_flow=12 THEN Flow_12=1; ELSE Flow_12=0;
	IF signup_flow=24 THEN Flow_24=1; ELSE Flow_24=0;
	IF signup_flow=25 THEN Flow_25=1; ELSE Flow_25=0;
	IF signup_flow=23 THEN Flow_23=1; ELSE Flow_23=0;
	IF signup_flow in (1 6 8 21) THEN Flow_other=1; ELSE Flow_other=0;
RUN;

PROC UNIVARIATE DATA=ModelDst; VAR AGE; RUN;
PROC FREQ DATA=ModelDst; TABLE AGE/MISSING; RUN;

DATA ModelDst; 
	SET ModelDst; 
	IF AGE < 18 THEN AGE=.; 
	IF AGE >=75 THEN AGE=.; 
RUN;

DATA ModelDst(DROP=YEAR MONTH DAY timestamp_first_active); 
	SET ModelDst; 
	YEAR=INPUT(SUBSTRN(timestamp_first_active, 1, 4), BEST4.);
	MONTH=INPUT(SUBSTRN(timestamp_first_active, 5, 2), BEST2.);
	DAY=INPUT(SUBSTRN(timestamp_first_active, 7, 2), BEST2.);
	First_Active=MDY(MONTH, DAY, YEAR);
	FORMAT First_Active YYMMDD10.; 
	INFORMAT First_Active YYMMDD10.;
RUN;

DATA ModelDst; 
	SET ModelDst; 
	Mth_BookingsinceActive = ROUND((date_first_booking - First_Active)/30, 1); 
	Mth_AcctCtnsinceActive = ROUND((date_account_created - First_Active)/30, 1);
	Mth_AcctCtnsBooking = ROUND((date_first_booking - date_account_created)/30, 1);
RUN;

PROC FREQ DATA=ModelDst; TABLE Mth_BookingsinceActive Mth_AcctCtnsinceActive Mth_AcctCtnsBooking/MISSING; RUN;

DATA ModelDst(DROP=date_account_created date_first_booking First_Active); 
	SET ModelDst; 
	IF Mth_BookingsinceActive >=13 THEN Mth_BookingsinceActive=13; 
	Days_AcctCtnsinceActive = (date_account_created - First_Active);
	IF Mth_AcctCtnsBooking >=31 THEN Days_AcctCtnsinceActive=31; 
	IF Mth_AcctCtnsBooking < 0 AND Mth_AcctCtnsBooking^=. THEN Mth_AcctCtnsBooking=.; 
RUN;

PROC FREQ DATA=ModelDst; TABLE Mth_BookingsinceActive 
Mth_AcctCtnsBooking/MISSING; RUN;

/******************************************************************************************************************************************/
/* EDA on Session Data */
/******************************************************************************************************************************************/
PROC SQL; 
	CREATE TABLE WebAction AS 
	SELECT DISTINCT USER_ID, ACTION, 1 AS N
	FROM SESSIONS 
	WHERE (USER_ID IS NOT NULL AND ACTION IS NOT NULL)
	AND USER_ID IN (SELECT DISTINCT ID FROM TRAIN_USERS); 
QUIT; 

PROC FREQ DATA=WebAction; TABLE ACTION; RUN;

PROC SQL; 
	CREATE TABLE WebActionType AS 
	SELECT DISTINCT USER_ID, action_type, 1 AS N
	FROM SESSIONS 
	WHERE (USER_ID IS NOT NULL AND action_type IS NOT NULL)
	AND USER_ID IN (SELECT DISTINCT ID FROM TRAIN_USERS); 
QUIT;

PROC FREQ DATA=WebActionType; TABLE action_type; RUN;

PROC SQL; 
	CREATE TABLE WebActionDetail AS 
	SELECT DISTINCT USER_ID, action_detail, 1 AS N
	FROM SESSIONS 
	WHERE (USER_ID IS NOT NULL AND action_detail IS NOT NULL)
	AND USER_ID IN (SELECT DISTINCT ID FROM TRAIN_USERS); 
QUIT; 

PROC FREQ DATA=WebActionDetail; TABLE action_detail; RUN;

DATA WebActionDetail; 
	SET WebActionDetail; 
	LENGTH New_Action $50.;
IF STRIP(action_detail) = "contact_host" 					THEN New_Action="contact_host";
IF STRIP(action_detail) = "message_inbox" 					THEN New_Action="contact_host";
IF STRIP(action_detail) = "message_post" 					THEN New_Action="contact_host";
IF STRIP(action_detail) = "message_thread" 					THEN New_Action="contact_host";
IF STRIP(action_detail) = "message_to_host_change" 			THEN New_Action="contact_host";
IF STRIP(action_detail) = "message_to_host_focus" 			THEN New_Action="contact_host";
IF STRIP(action_detail) = "create_listing" 					THEN New_Action="listing";
IF STRIP(action_detail) = "delete_listing" 					THEN New_Action="listing";
IF STRIP(action_detail) = "delete_listing_description" 		THEN New_Action="listing";
IF STRIP(action_detail) = "delete_phone_numbers" 			THEN New_Action="listing";
IF STRIP(action_detail) = "list_your_space" 				THEN New_Action="listing";
IF STRIP(action_detail) = "listing_descriptions" 			THEN New_Action="listing";
IF STRIP(action_detail) = "listing_recommendations" 		THEN New_Action="listing";
IF STRIP(action_detail) = "listing_reviews" 				THEN New_Action="listing";
IF STRIP(action_detail) = "listing_reviews_page" 			THEN New_Action="listing";
IF STRIP(action_detail) = "manage_listing" 					THEN New_Action="listing";
IF STRIP(action_detail) = "update_listing" 					THEN New_Action="listing";
IF STRIP(action_detail) = "update_listing_description" 		THEN New_Action="listing";
IF STRIP(action_detail) = "user_listings" 					THEN New_Action="listing";
IF STRIP(action_detail) = "view_listing" 					THEN New_Action="listing";
IF STRIP(action_detail) = "your_listings" 					THEN New_Action="listing";
IF STRIP(action_detail) = "cancellation_policies" 			THEN New_Action="policy";
IF STRIP(action_detail) = "cancellation_policy_click" 		THEN New_Action="policy";
IF STRIP(action_detail) = "view_search_results" 			THEN New_Action="search";
IF STRIP(action_detail) = "similar_listings" 				THEN New_Action="similar_listings";
IF STRIP(action_detail) = "translate_listing_reviews" 		THEN New_Action="translate";
IF STRIP(action_detail) = "translations" 					THEN New_Action="translate";
IF STRIP(action_detail) = "-unknown-" 						THEN New_Action="unknown";
IF STRIP(action_detail) = "account_notification_settings" 	THEN New_Action="user_acct";
IF STRIP(action_detail) = "account_payout_preferences" 		THEN New_Action="user_acct";
IF STRIP(action_detail) = "account_privacy_settings" 		THEN New_Action="user_acct";
IF STRIP(action_detail) = "account_transaction_history" 	THEN New_Action="user_acct";
IF STRIP(action_detail) = "confirm_email" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "confirm_email_link" 				THEN New_Action="user_acct";
IF STRIP(action_detail) = "create_user" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "edit_profile" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "forgot_password" 				THEN New_Action="user_acct";
IF STRIP(action_detail) = "update_user" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "update_user_profile" 			THEN New_Action="user_acct";
IF STRIP(action_detail) = "user_friend_recommendations" 	THEN New_Action="user_acct";
IF STRIP(action_detail) = "user_languages" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "user_profile" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "user_profile_content_update" 	THEN New_Action="user_acct";
IF STRIP(action_detail) = "user_reviews" 					THEN New_Action="user_acct";
IF STRIP(action_detail) = "user_social_connections" 		THEN New_Action="user_acct";
IF STRIP(action_detail) = "email_wishlist" 					THEN New_Action="wishlist";
IF STRIP(action_detail) = "email_wishlist_button" 			THEN New_Action="wishlist";
IF STRIP(action_detail) = "friends_wishlists" 				THEN New_Action="wishlist";
IF STRIP(action_detail) = "user_wishlists" 					THEN New_Action="wishlist";
IF STRIP(action_detail) = "wishlist" 						THEN New_Action="wishlist";
IF STRIP(action_detail) = "wishlist_content_update" 		THEN New_Action="wishlist";
IF STRIP(action_detail) = "wishlist_note" 					THEN New_Action="wishlist";
RUN;

PROC SQL; 
	CREATE TABLE NEW_WEBACTION AS 
	SELECT DISTINCT USER_ID AS ID, New_Action AS WebAction, 1 AS IND
	FROM WebActionDetail 
	WHERE New_Action^='' AND New_Action^="unknown"; 
QUIT;

PROC FREQ DATA=NEW_WEBACTION; TABLE WebAction; RUN;

PROC SORT DATA=NEW_WEBACTION; BY ID WebAction; RUN;

PROC TRANSPOSE DATA=NEW_WEBACTION OUT=WebData(DROP=_NAME_);
	BY ID;
	ID WebAction; 
	VAR IND; 
RUN;

DATA WebData; 
	SET WebData; 
	IF contact_host=. THEN contact_host=0; 
	IF listing=. THEN listing=0; 
	IF policy=. THEN policy=0; 
	IF search=. THEN search=0; 
	IF similar_listings=. THEN similar_listings=0; 
	IF translate=. THEN translate=0; 
	IF user_acct=. THEN user_acct=0; 
	IF wishlist=. THEN wishlist=0; 
RUN;

PROC SQL; 
	CREATE TABLE NewModelDst AS 
	SELECT A.*, B.*
	FROM ModelDst AS A LEFT JOIN WebData AS B
	ON A.ID=B.ID; 
QUIT;

PROC MEANS DATA=NewModelDst N NMISS; RUN;

DATA NewModelDst; 
	SET NewModelDst; 
	IF AGE =. THEN AGE=-99; 
	IF Mth_BookingsinceActive=. THEN Mth_BookingsinceActive=-99; 
	IF Mth_AcctCtnsBooking=. THEN Mth_AcctCtnsBooking=-99; 
	IF contact_host=. THEN contact_host=-1; 
	IF search=. THEN search=-1; 
	IF similar_listings=. THEN similar_listings=-1; 
	IF user_acct=. THEN user_acct=-1; 
	IF wishlist=. THEN wishlist=-1; 
	IF listing=. THEN listing=-1; 
	IF translate=. THEN translate=-1; 
	IF policy=. THEN policy=-1; 
RUN;

DATA NewModelDst; 
	SET NewModelDst(DROP=Mth_AcctCtnsinceActive Days_AcctCtnsinceActive);
RUN; 

proc freq data=newmodeldst; table country_destination; run;

DATA NewModelDst; 
	SET NewModelDst; 
IF country_destination="AU" THEN Target=0;
IF country_destination="CA" THEN Target=1;
IF country_destination="DE" THEN Target=2;
IF country_destination="ES" THEN Target=3;
IF country_destination="FR" THEN Target=4;
IF country_destination="GB" THEN Target=5;
IF country_destination="IT" THEN Target=6;
IF country_destination="NDF" THEN Target=7;
IF country_destination="NL" THEN Target=8;
IF country_destination="PT" THEN Target=9;
IF country_destination="US" THEN Target=10;
IF country_destination="other" THEN Target=11;
RUN;
 
