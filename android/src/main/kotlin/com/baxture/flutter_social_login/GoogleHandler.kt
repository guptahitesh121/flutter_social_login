package com.baxture.flutter_social_login

import android.app.Activity
import android.content.Intent
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException


class GoogleHandler {

    private var onLoginResult: ((SocialUser?, Throwable?) -> Unit)? = null

    fun login(activity: Activity, callback: (SocialUser?, Throwable?) -> Unit) {
        GoogleSignIn.getLastSignedInAccount(activity)?.let {
            callback(it.toSocialUser(), null)
        } ?: run {
            onLoginResult = callback
            val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestEmail().build()
            val client = GoogleSignIn.getClient(activity, gso);
            val signInIntent: Intent = client.signInIntent
            activity.startActivityForResult(signInIntent, RC_SIGN_IN)
        }
    }

    fun getCurrentUser(activity: Activity): SocialUser? =
            GoogleSignIn.getLastSignedInAccount(activity)?.toSocialUser()

    fun logOut(activity: Activity, callback: () -> Unit) {
        GoogleSignIn.getClient(activity, GoogleSignInOptions.Builder().build())
                .signOut()
                .addOnCompleteListener { callback() }
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != RC_SIGN_IN) {
            return false
        }
        if (resultCode == Activity.RESULT_CANCELED) {
            onLoginResult?.invoke(null, null)
            return true
        }
        try {
            val account =
                    GoogleSignIn.getSignedInAccountFromIntent(data).getResult(ApiException::class.java)
            onLoginResult?.invoke(account?.toSocialUser(), null)
        } catch (e: ApiException) {
            onLoginResult?.invoke(null, e)
        }
        return true
    }

    private fun GoogleSignInAccount.toSocialUser(): SocialUser =
            SocialUser(
                    id,
                    email,
                    displayName,
                    photoUrl?.toString(),
                    mapOf(Constants.GOOGLE_ID_TOKEN to idToken)
            )

    companion object {
        private const val RC_SIGN_IN = 424242
    }
}