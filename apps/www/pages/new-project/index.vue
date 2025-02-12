<template>
  <main>
    <div class="project-hero" />
    <div class="project-container">
      <div class="container mx-auto flex items-start">
        <section class="bg-white dark:bg-gray-700 dark:text-white w-full rounded-lg p-6">
          <h1
            v-text="$trans('project.titles.new-project')"
            class="font-medium text-2xl mb-4"
          />
          <ValidationObserver
            ref="observer"
          >
            <form
              :disabled="$wait.is('creating new project')"
              @submit.prevent="submitted"
            >
              <div class="flex flex-col md:flex-row">
                <div
                  class="md:w-1/2 md:mr-8"
                >
                  <h2
                    v-text="$trans('project.titles.informations')"
                    class="font-medium text-lg text-gray-700 dark:text-gray-300 mb-4"
                  />

                  <ValidationProvider
                    rules="required"
                    :name="$trans('project.labels.name').toLowerCase()"
                    v-slot="{ errors, invalid, dirty }"
                    tag="div"
                    class="flex flex-col mb-4"
                  >
                    <label
                      for="project-name"
                      v-text="`${$trans('project.labels.name')} *`"
                      class="mb-2"
                    />
                    <input
                      v-model="formData.name"
                      :class="{
                        'input--invalid': errors.length || (invalid && dirty)
                      }"
                      type="text"
                      name="project-name"
                      id="project-name"
                      class="input"
                      required
                    >
                    <div
                      v-if="errors.length || (invalid && dirty)"
                      v-text="errors[0]"
                      class="text-red-600 text-sm"
                    />
                  </ValidationProvider>

                  <ValidationProvider
                    rules="required|min:2|max:32"
                    :name="$trans('project.labels.slug').toLowerCase()"
                    v-slot="{ errors, invalid, dirty }"
                    tag="div"
                    class="flex flex-col mb-4"
                  >
                    <label
                      for="slug"
                      v-text="`${$trans('project.labels.slug')} *`"
                      class="mb-2"
                    />
                    <input
                      v-model="formData.slug"
                      :class="{
                        'input--invalid': errors.length || (invalid && dirty)
                      }"
                      type="text"
                      name="slug"
                      id="slug"
                      class="input"
                      required
                    >
                    <div
                      v-text="$trans('global.paragraphs.max_chars', {
                        chars: 32
                      })"
                      class="text-gray-600 dark:text-gray-400 text-sm"
                    />
                    <div
                      v-if="errors.length || (invalid && dirty)"
                      v-text="errors[0]"
                      class="text-red-600 text-sm"
                    />
                  </ValidationProvider>

                  <ValidationProvider
                    rules="max:255"
                    :name="$trans('project.labels.description').toLowerCase()"
                    v-slot="{ errors, invalid, dirty }"
                    tag="div"
                    class="flex flex-col mb-4"
                  >
                    <label
                      for="description"
                      v-text="$trans('project.labels.description')"
                      class="mb-2"
                    />
                    <textarea
                      v-model="formData.description"
                      :class="{
                        'textarea--invalid': errors.length || (invalid && dirty)
                      }"
                      name="description"
                      id="description"
                      class="textarea"
                    ></textarea>
                    <div
                      v-text="$trans('global.paragraphs.max_chars', {
                        chars: 255
                      })"
                      class="text-gray-600 dark:text-gray-400 text-sm"
                    />
                    <div
                      v-if="errors.length || (invalid && dirty)"
                      v-text="errors[0]"
                      class="text-red-600 text-sm"
                    />
                  </ValidationProvider>


                  <ValidationProvider
                    :name="$trans('project.labels.url').toLowerCase()"
                    v-slot="{ errors, invalid, dirty }"
                    tag="div"
                    class="flex flex-col mb-4"
                  >
                    <label
                      for="url"
                      v-text="$trans('project.labels.url')"
                      class="mb-2"
                    />
                    <input
                      v-model="formData.url"
                      :class="{
                        'input--invalid': errors.length || (invalid && dirty)
                      }"
                      type="url"
                      name="url"
                      id="url"
                      class="input"
                    >
                    <div
                      v-if="errors.length || (invalid && dirty)"
                      v-text="errors[0]"
                      class="text-red-600 text-sm"
                    />
                  </ValidationProvider>
                </div>
                <div class="md:w-1/2">
                  <div class="mr-8 flex-shrink-0 mb-4">
                    <AppAvatar
                      :src="previewUrl"
                      width="150"
                      height="150"
                    />
                  </div>
                  <div class="text-gray-700 dark:text-gray-300">
                    <h3
                      v-text="$trans('project.titles.logo')"
                      class="text-lg font-medium mb-2"
                    />
                    <div class="mb-3 border border-solid border-gray-300 dark:border-gray-600 rounded p-2">
                      <input
                        type="file"
                        name="image"
                        id="image"
                        accept="image/*"
                        class="w-full"
                        @change="fileChange"
                      >
                    </div>
                    <h3
                      v-text="$trans('settings.titles.profile_rules')"
                      class="text-base font-medium mb-2"
                    />
                    <p
                      v-text="$trans('settings.paragraphs.profile_rules')"
                      class="text-base mb-1"
                    />
                    <ul class="text-base list-disc pl-4 mb-8">
                      <li
                        v-text="$trans('settings.paragraphs.profile_rules.racism')"
                      />
                      <li
                        v-text="$trans('settings.paragraphs.profile_rules.nsfw')"
                      />
                    </ul>
                  </div>
                </div>
              </div>
              <div>
                <button
                  :disabled="$wait.is('creating new project')"
                  type="submit"
                  class="btn btn-primary"
                  v-text="$trans('global.buttons.save')"
                />
              </div>
            </form>
          </ValidationObserver>
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    middleware: ['authenticated'],
    data () {
      return {
        previewUrl: require('@/assets/img/default-avatar.png'),
        formData: {
          logo: null,
          name: null,
          slug: null,
          description: null,
          url: null
        } as {
          logo: Blob|null
          name: string|null
          slug: string|null
          description: string|null
          url: string|null
        }
      }
    },
    methods: {
      fileChange (e: Event) {
        if (e) {
          const file = (e.target as HTMLInputElement).files[0]

          this.formData.logo = file
          const reader = new FileReader()
          reader.onload = v => {
            this.previewUrl = v.target.result
          }

          reader.readAsDataURL(file)
        }
      },
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { name, slug, description, url, logo } = this.formData

            const formData = new FormData()
            formData.append('name', name as string)
            formData.append('slug', slug as string)
            if (description) formData.append('description', description)
            if (url) formData.append('url', url)
            if (logo) formData.append('avatar', logo)

            this.$wait.start('creating new project')
            this.$axios.post('/me/projects', formData, {
              headers: {
                'Content-Type': 'multipart/form-data'
              }
            })
              .then((res) => {
                this.$accessor.pushAuthProject(res.data)

                this.$router.push({
                  name: 'Project',
                  params: {
                    slug: res.data.slug
                  }
                })

                this.$toasted.success(this.$trans('project.paragraphs.created'))
              })
              .finally(() => {
                this.$wait.end('creating new project')
              })
          })
      }
    },
    head () {
      return {
        title: this.$trans('project.titles.new-project')
      }
    }
  })
</script>

<style scoped>
  .project-hero {
    min-height: 320px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
    padding-bottom: 180px;
  }

  .project-container {
    margin-top: -250px;
  }
</style>
