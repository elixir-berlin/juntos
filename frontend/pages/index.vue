<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <h1>Events</h1>
      <ul>
        <li v-for="auth in authProvider.authProviders" :key="auth.id">
          Login with
          <a :href="authUrlWithParams(auth)">{{ auth.authType }}</a>
        </li>
      </ul>
    </v-flex>
  </v-layout>
</template>

<script>
// eslint-disable
import { mapState } from 'vuex'

export default {
  computed: mapState(['authProvider', 'authProviders']),
  methods: {
    authUrlWithParams(auth) {
      const juntoRedirectPath =
        window.location.protocol +
        '//' +
        window.location.host +
        '/oauth2/' +
        auth.authType.toLowerCase() +
        '/callback'
      return (
        auth.authUrl +
        '?client_id=' +
        auth.clientId +
        '&redirect_uri=' +
        encodeURIComponent(juntoRedirectPath)
      )
    }
  }
}
</script>
