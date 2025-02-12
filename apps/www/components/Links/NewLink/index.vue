<template>
  <apollo-mutation
    :mutation="createLink"
    :variables="{
      url: formData.url
    }"
    :update="updateCache"
    @done="done"
  >
    <template v-slot="{ mutate, loading, error }">
      <ValidationObserver
        ref="observer"
      >
        <form
          :disabled="loading"
          class="flex flex-col"
          @submit.prevent="mutate"
        >
          <label
            for="url"
            class="mb-2"
          >
            {{ $trans('links.labels.link') }}
          </label>
          <ValidationProvider
            rules="required"
            class="flex flex-col md:flex-row md:items-center"
            tag="div"
          >
            <input
              v-model="formData.url"
              type="url"
              name="url"
              id="url"
              class="input mr-4 mb-4 md:mb-0"
              placeholder="URL"
              required
            >

            <button
              :disabled="loading"
              type="submit"
              class="btn btn-primary"
            >
              {{ $trans('links.buttons.publish') }}
            </button>
          </ValidationProvider>
          <div
            v-if="error"
            class="text-red-500"
            v-text="error"
          />
        </form>
      </ValidationObserver>
    </template>
  </apollo-mutation>
</template>

<script lang="ts">
  import { defineComponent, reactive } from '@vue/composition-api'
  import allLinks from '~/apollo/queries/allLinks'

  import gql from 'graphql-tag'

  export default defineComponent({
    setup () {
      const formData = reactive({
        url: null
      })

      const createLink = gql`
        mutation ($url: String!) {
          create_link(input: { url: $url }) {
            link {
              uuid
              title
              url
              created_at
              user {
                uuid
                username
                first_name
                last_name
                avatar_url
              }
            }
          }
        }
      `

      /**
       * Once we have the data, we want to update the list of links.
       * Fetch the allLinks query to append on top of the list the new link
       */
      function updateCache (cache, { data: { create_link: link } }) {
        const data = cache.readQuery({ query: allLinks })
        data.all_links.nodes.unshift(link.link)
        cache.writeQuery({ query: allLinks, data })
      }

      function done () {
        formData.url = null
      }

      return {
        done,
        formData,
        createLink,
        updateCache
      }
    }
  })
</script>
