package com.baxture.flutter_social_login

data class SocialConfig(val facebookAppId: String? = null) {

    companion object {

        private const val KEY_FACEBOOK_APP_ID = "facebook_app_id"

        fun fromMap(map: Map<*, *>): SocialConfig =
                SocialConfig(
                        facebookAppId = map[KEY_FACEBOOK_APP_ID] as? String
                )

        val EMPTY = SocialConfig()
    }
}