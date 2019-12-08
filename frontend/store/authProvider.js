import allAuthProviders from '@/apollo/queries/allAuthProviders.gql'

export const state = () => {
  authProviders: []
}

export const mutations = {
  SET_AUTH_PROVIDERS(state, authProviders) {
    state.authProviders = authProviders
  }
}

export const actions = {
  async all({ commit }) {
    let client = this.app.apolloProvider.defaultClient

    const query = {
      query: allAuthProviders
    }
    const response = await client.query(query)
    commit('SET_AUTH_PROVIDERS', response.data.allAuthProviders)
  }
}
