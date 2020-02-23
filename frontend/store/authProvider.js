import allAuthProviders from '@/apollo/queries/allAuthProviders.gql'

export const state = () => ({
  authProviders: []
})

export const mutations = {
  SET_AUTH_PROVIDERS(state, authProviders) {
    state.authProviders = authProviders
  }
}

export const actions = {
  async all({ commit }, apolloProvider) {
    const query = {
      query: allAuthProviders
    }
    const response = await apolloProvider.query(query)
    commit('SET_AUTH_PROVIDERS', response.data.authProviders)
  }
}
