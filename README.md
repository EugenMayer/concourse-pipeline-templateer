[![Gem Version](https://badge.fury.io/rb/ctpl.svg)](https://badge.fury.io/rb/ctpl)

## WAT

A Concourse pipeline and it's defintion in `pipeline.yaml` becomes huge, clunky and messy very fast. `ctpl` to the rescue.

This tool enables you to split your `pipeline.yml` into several structural files - as many as you like - 
and compiles it for usage with `fly`. The`pipeline.yml` has properly merged `jobs`/`resource_types`/`resources`/`groups`

You can split as granular as you like.
 
**Check some example projects**

- [concourse-app-release-lifecycle-example](https://github.com/kw-concourse-example/concourse-app-release-lifecycle-example)

## Installation

```console
gem install ctpl
```
## Quick start

Example project with real multi-stage pipeline and several resources

```consule
git clone https://github.com/kw-concourse-example/concourse-app-release-lifecycle-example
cd ci
ctpl
```

Now check the generated `./pipeline.yaml` in your CWD and compare the source in `ci/pipeline/`
 
## Usage

1. Create a folder `pipeline` in your e.g. `ci` folder `ci/pipeline`
2. Move your `ci/pipeline.yaml` to `ci/pipeline/pipeline-template.yaml`

Now run the generation

```console
cd ci
ctpl
# above assumed that your base folder is ./pipeline and the file should be generated to ./pipeline.yaml 
# that's just the default - more to come
```

That's about it for the first step - now is the best time to run and read

```console
ctpl help
```

Now go on and split your `pipeline.yaml` into for example

- `ci/pipeline/resources/_resources_git.yml`
- `ci/pipeline/resources/_resources_docker.yml`
- `ci/pipeline/jobs/_staging.yml`
- `ci/pipeline/jobs/_candidate.yml`
- `ci/pipeline/jobs/_release.yml`

This is just an example, you could not use folders at all or even deeper nesting. The only rule is, all "partials"
so all files to be merged into your main `ci/pipeline/pipeline-template.yaml` must begin match this glob

partial: `_*.yaml`

I kept the actual "format" fairly open, so you can work 
 - with folder or without folders, or any level of subfolders
 - you could group your partials by `jobs` (so a job and it's resources)
 - you could also rather group by type, so group `jobs`, `resources` into several files
 - you could create a file per job/resource even or combine them
 - you can still/also/in addition define resources/jobs .. and so on in your `pipeline.yaml`- they all get merged
 
Or you can just mix all those anytime as you like.

### Advanced 

#### Options

List all options using `ctpl help` but in general you have a usecase like

This assumes your `pipeline-template.yaml` is at `./pipeline_special/pipeline-template.yaml` and generates the result to `/tmp/pipeline.yaml`

```console
ctpl -b ./pipeline_special -o /tmp/pipeline.yaml
```

#### Global Aliases

You might want to define global aliases which should be available for all your partials, e.g. for notifications, failures
or whatever suits you. For this, there is a special file `<basefolder>/aliases.yaml` so with the example here
`ci/pipeline/aliases.yaml` - now you can put things into that like

```yaml
failure_params: &failure_params
  params:
    color:                red
    notify:               true
    from:                 "Concourse CI"
    message:
      template:           'Failed'
    message_format:       html
```

And now use this in your partials as it would have been defined in the partial itself. Reuse - reuse - reuse.

#### Local aliases

You can of course have aliases which you define in the partials locally, but please be aware that those should not conflict
with any other alias or they could colide. If you need an alias in more then one partial, put it under `aliases.yaml`

## FAQ

**Is the `<basefolder>/pipeline-template.yaml` file required**

No

---

**Is the `<basefolder>/aliases.yaml` file required**

No

--- 

**Is can you use custom keys in your partials**

Yes - any. We only merge `jobs`/`resource_types`/`resources`/`groups` - anything else is just combined as yaml would do it
This also means, that if you have several things defining a toplevel `foo: bar` - the one included as the last one wins

---

**Can i have several different pipelines**

Yes, e.g. create `ci/pipeline_a` / `ci/pipeline_b` `ci/pipeline_c` and then run

```console
cd ci
ctpl -b ./pipeline_a -o pipeline_a.yaml
ctpl -b ./pipeline_b -o pipeline_b.yaml
ctpl -b ./pipeline_c -o pipeline_c.yaml
```

---

**Can i define a order**
The glob is sorted, for now all you can do is using things like
 
- `ci/pipeline/_1_staging.yml`
- `ci/pipeline/_2_candidate.yml`
- `ci/pipeline/_3_release.yml`

This would put the staging jobs/resources first, then candidate then releases.

## Test

```console
cd test/assets
ctpl -b pipeline_a -o pipeline_a.yaml
ctpl -b pipeline_min -o pipeline_min.yaml
```

## Why ruby?

Implementing this feature in golang does need a lot more effort due to the way we can "unserialize" a "unknown" yaml structure
and just merge some aspects and keep anything else in place until then.

If you feel lucky and want to try to implement in golang as a drop in to `ctpl` - please keep me posted! Very interesting.


## Contribute / Features

Yes please, i beg you :) - But please do not open FR in issues when you do not want to work on them yourself - only for pre-discussions.
