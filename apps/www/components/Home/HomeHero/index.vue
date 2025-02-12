<template>
  <div class="home-hero">
    <div class="home-hero__avatars-container absolute w-full hidden md:block overflow-x-hidden pointer-events-none">
      <div class="home-hero__avatars container mx-auto relative">
        <HomeHeroAvatars
          :users="computedUsers.slice(0, 5)"
          class="home-hero__avatars--left"
        />
        <HomeHeroAvatars
          :users="computedUsers.slice(5, 10)"
          class="home-hero__avatars--right"
        />
      </div>
    </div>
    <div class="container mx-auto">
      <div class="flex items-center text-center flex-col py-8">
        <div class="home-hero__wrapper">
          <h1
            class="text-3xl md:text-5xl font-medium text-white leading-tight mb-4"
            v-text="$trans('home.titles.main')"
          />
          <h2
            class="text-lg md:text-2xl text-white text-opacity-75"
            v-text="$trans('home.titles.subtitle')"
          />
        </div>
        <div
          v-if="!$accessor.isAuthenticated"
          class="mt-8 flex items-center"
        >
          <nuxt-link
            :to="{
              name: 'SignUp'
            }"
            class="inline-block bg-white rounded text-blue-500 p-4 font-medium text-base hover:bg-gray-200 hover:shadow-sm mr-4 dark:bg-blue-500 dark:text-white dark:hover:bg-blue-400"
          >
            {{ $trans('home.buttons.join') }}
          </nuxt-link>
          <a
            href="https://discord.gg/VM3rH2X68P"
            target="_blank"
            rel="noopener"
            class="flex bg-white rounded text-blue-500 p-4 hover:bg-gray-200 hover:shadow-sm dark:bg-gray-700 dark:hover:bg-gray-600"
          >
            <svg
              width="24"
              height="24"
              role="img"
              viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"
              class="text-blue-500 dark:text-white"
            ><title>Discord icon</title><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z" class="fill-current"/></svg>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, computed } from '@vue/composition-api'
  import { useQuery, useResult } from '@vue/apollo-composable/dist'
  import gql from 'graphql-tag'

  import AppAvatar from '@/components/AppAvatar/index.vue'
  import HomeHeroAvatars from './HomeHeroAvatars/index.vue'
  import { User } from '~/types/user'

  export default defineComponent({
    components: {
      AppAvatar,
      HomeHeroAvatars
    },
    setup() {
      const { result } = useQuery(gql`
        {
          random_users {
            uuid
            avatar_url
            streak
          }
        }
      `)

      const users = useResult(result, null, data => data.random_users)
      const computedUsers = computed(() => {
        if (!users.value) return []

        return users.value.map((user: User & { avatarUrl: string }) => ({
          size: 50 + Math.round(Math.random() * 20),
          user: user
        }))
      })

      return {
        computedUsers
      }
    }
  })
</script>

<style scoped>
  .home-hero {
    min-height: 320px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
    padding-bottom: 100px;
  }

  .dark .home-hero {
    background: rgba(31, 41, 55, var(--tw-bg-opacity));
  }

  .home-hero__wrapper {
    max-width: 550px;
  }

  .home-hero__avatars {
    min-height: 320px;
  }

  @screen md {
    .home-hero__avatars--left {
      left: -150px;
    }
  }

  @screen lg {
    .home-hero__avatars--left {
      left: -80px;
    }
  }

  @screen md {
    .home-hero__avatars--right {
      right: -150px;
    }
  }

  @screen lg {
    .home-hero__avatars--right {
      right: -80px;
    }
  }

  @screen md {
    .home-hero {
      min-height: 400px;
      padding-bottom: 180px;
    }
  }
</style>
