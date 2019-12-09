//https://vuex.vuejs.org/guide/testing.html
//const actionsInjector = require('inject-loader!.nuxt/store')
import * as authProvider from '@/store/authProvider'
import VueApollo from 'vue-apollo'

import { createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import { cloneDeep } from 'lodash'
import { async } from 'q'

//const actionsInjector = require('inject-loader!@/store/authProvider')

const testAction = (action, payload, state, expectedMutations, done) => {
  let count = 0

  // mock commit
  const commit = (type, payload) => {
    const mutation = expectedMutations[count]

    try {
      expect(type).to.equal(mutation.type)
      if (payload) {
        expect(payload).to.deep.equal(mutation.payload)
      }
    } catch (error) {
      done(error)
    }

    count++
    if (count >= expectedMutations.length) {
      done()
    }
  }

  // call the action with mocked store and arguments
  action({ commit, state }, payload)

  // check if no mutations should have been dispatched
  if (expectedMutations.length === 0) {
    expect(count).to.equal(0)
    done()
  }
}

describe.skip('authProvider Store', () => {
  test('SET_AUTH_PROVIDERS mutation', () => {
    const state = {
      authProviders: []
    }
    authProvider.mutations.SET_AUTH_PROVIDERS(state, [{ id: 1 }])
    expect(state.authProviders.length).toBe(1)
  })
  test('whole shit', async done => {
    const localVue = createLocalVue()
    localVue.use(Vuex)
    localVue.use(VueApollo)

    const store = new Vuex.Store({
      state: { authProviders: [] },
      actions: authProvider.actions
    })
    authProvider.app = localVue

    //const store = new Vuex.Store(s)

    expect(store.state.authProviders.length).toBe(0)

    testAction(
      authProvider.actions.all,
      null,
      {},
      [{ type: 'SET_AUTH_PROVIDERS' }],
      done
    )
  })
})
