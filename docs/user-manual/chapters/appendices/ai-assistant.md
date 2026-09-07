---
title: The AI Assistant
chapter_id: appendices/ai-assistant
audience: bench-scientist
prereqs: [01-foundations/06-the-lungfish-project]
estimated_reading_min: 16
task: Open the Inspector's Assistant tab, connect a bring-your-own-key provider, and ask questions about the dataset that is open.
tags: [ai-assistant, reference, byo-key, help]
tools: []
entry_points:
  - "View > AI Assistant"
shots:
  - id: ai-assistant-panel
    caption: "The Assistant tab of the Inspector beside a dataset viewport, showing the welcome message, the suggested-question buttons, and the Data sent and Clear buttons in its header."
  - id: ai-assistant-provider-setup
    caption: "The AI Services settings tab with the Enable AI-powered search toggle, the Default provider picker, and one provider's API Key field, key-status indicator, and Model picker."
  - id: ai-assistant-azure-endpoint
    caption: "The Azure AI section of the AI Services settings tab, with the Use Azure AI-hosted endpoint toggle and the Endpoint and Deployment fields."
illustrations: []
glossary_refs: [ai-assistant, api-key, keychain, provenance, bundle, viewport, sidebar, table-drawer, operations-panel, grounded-answer, provider-fallback, contig]
features_refs: [ai.assistant]
fixtures_refs: [demo-project]
brand_reviewed: true
lead_approved: true
---

## What it is

The AI Assistant is a chat tab inside Lungfish Genome Explorer (LGE) that answers questions about the dataset you have open. It lives in the Inspector, the pane on the right of the project window that shows details for whatever you have selected. Rather than hunting through menus, you type a plain question such as "what is in this bundle?" and read the reply in that tab.

The assistant automatically gathers the state of the active viewport, which is the large display in the middle of the window that draws your loaded data. That state means the loaded bundle, which is a folder of files LGE treats as one item, the organism, the region on screen, and the rows you have selected in the variant or sample tables. Those tables live in the table drawer, the panel that slides up from the bottom edge of a reference bundle viewport. Gathering that state is what lets an answer refer to what is actually in front of you.

This is a bring-your-own-key feature. LGE includes no model of its own and runs none for you. You hold an account with an outside company that serves a large language model, which is a program trained on text that produces text in reply, and you give LGE the API key for that account. An API key is a long secret string that identifies your account to a service, in the same way a password identifies you to a website. Every question you ask travels to that company under your key, is billed to your account, and is answered by their model, not by anything running on your Mac.

Two consequences follow from that arrangement. They matter more than any feature described later in this appendix. The first is that your data leaves your machine. The context the assistant assembles, including bundle names, sample names, and selected variant rows, is sent to the provider you configured. The second is that the reply is generated text, not a computed result. LGE records nothing an assistant says into your project's provenance. Provenance is the record of which tool, at which version, with which parameters, produced each file. Use the assistant to interpret and to orient yourself, and confirm anything you intend to publish by checking it in the viewport, in the Operations panel, which is the window listing every job LGE has run and how it ended, or on the command line.

<!-- SHOT: ai-assistant-panel -->

## Why you would do this

Opening a project someone else built is where the assistant is most useful. The demo project holds a mixed collection, and the counts below describe that one project rather than a size to aim for.

Under `Reference Sequences/`, a folder you see in the sidebar, which is the list of your project's contents down the left of the window, sit two reference bundles. Reference bundles hold sequence you compare things against. One is the HG002 chromosome 20 slice, a 500,000-base region of human chromosome 20 running from 10.0 to 10.5 Mb. The other is the HBB gene record. Under `Imports/` sit three read bundles, each holding one sample's sequencing reads. Under `Analyses/` sit five outputs from tools LGE ran, among them an assembly of the HG002 mitochondrial reads built by SPAdes and a read classification built by Kraken 2. An assembly joins overlapping reads into longer stretches of sequence, and a classification labels each read with the organism it most likely came from.

A reader meeting that project for the first time has questions the sidebar cannot answer on its own. Which chromosomes does the HG002 chromosome 20 slice actually contain? How many variants sit in its variant track, the row of called differences drawn along the sequence? How do those variants break down by type?

Those are the questions the assistant is built for, because each one is a lookup against data already loaded rather than a judgement about biology. A question such as "is this variant pathogenic?" is not a lookup, and the assistant answers it from the model's general reading rather than from your project. The assistant can run the lookups itself, read the answers back, and put them into a sentence. It is at its weakest when a question needs data that is not loaded, and at its most useful when it is explaining a result you are looking at.

## Before you start

Nothing else in this manual depends on this appendix, and no analysis in LGE requires an AI provider, so you can stop here without losing any capability.

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This appendix uses the demo project. Build it by following the instructions in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/demo-project, which have you create the project in the app at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` and then fill it in about two minutes.

The Assistant tab appears only when a genomics bundle is loaded, meaning a reference bundle such as the HG002 chromosome 20 slice. Select a FASTQ bundle, an assembly, a mapping result, a classifier result such as the demo project's Kraken 2 run, or a genotype bundle, and the Inspector opens without an Assistant tab and without an explanation. Select the HG002 chromosome 20 slice under `Reference Sequences/` before you go looking for the tab.

You also need an account with one of three companies, and a key from it. LGE supports Anthropic, OpenAI, and Google Gemini. You create the account on that provider's own website, which is also where the provider issues your key, and signing up asks for payment details. Each provider charges per question at its own rates, which this manual does not quote, so check the provider's published prices before you decide how much to ask. Once the toggle described in step 2 is on, the Assistant tab opens and shows its suggested questions even with no key entered, but every question you send comes back with a message saying the API key is not configured and pointing you at **Settings > AI Services**. A brand-new empty project shows only one suggested question rather than the set described in step 4, because no bundle is loaded yet.

Set aside about twenty minutes to work through this appendix, most of it spent creating the provider account rather than in LGE.

## Procedure

### Step 1. Open the AI Services settings tab

Choose **Settings...** (Cmd-,) from the application menu, the menu named after the app at the left of the menu bar, and click **AI Services**. This tab holds everything the assistant needs. Leave it open for the next three steps.

### Step 2. Turn on AI-powered search

Turn on the toggle at the top of the tab, whose label reads `Enable AI-powered search`. It sits alone above every other control, so it is hard to mistake for another one. It is off by default on a new installation, and turning it on by itself sends nothing anywhere, because no question has been asked yet.

While it is off there is no assistant to type into. The Assistant tab does not appear, and **View > AI Assistant** raises an alert headed "AI Assistant Disabled" whose text reads `Enable AI-powered search in Settings > AI Services to use the assistant.`

### Step 3. Choose a default provider and enter its key

Choose a company from the picker whose label reads `Default provider:` on screen, with three options reading "Anthropic Claude", "OpenAI", and "Google Gemini". Then find the section named for that company further down the tab, and type or paste your key into its **API Key** field. Each provider's field shows the shape its keys take as grey placeholder text, which is example text that disappears once you start typing rather than a value already entered. Those shapes are `sk-ant-...` for Anthropic, `sk-...` for OpenAI, and `AIza...` for Google Gemini. The prefix is already part of the key the provider gives you, so you do not type it yourself.

Type the key only into that field. It is the one place in LGE built to receive it, and the only place LGE can store it safely. LGE writes the key into the macOS Keychain, the system store that holds passwords and other secrets under the protection of your login, and never into your project folder. The key saves by itself as you type, with no Save button to press, and a short line reading "Saving API key changes to Keychain…" appears under the form while the write is in progress. Nothing about the key is copied into a `.lungfish` folder, so a colleague who receives your project does not receive your key. Return to this same field later to replace a key with a new one.

A small indicator sits to the left of each key field and reports what LGE knows about that key. Watch it after you type, because it is the only confirmation you get. A grey minus sign means the field is empty. An orange hourglass means a key is entered but has not been checked yet, or is being checked right now, with the caption reading "Validating API key and quota..." during the check. A green filled checkmark means the key was accepted, with the caption "Key is valid and ready for AI queries." A red filled cross means the check failed, with a caption naming the reason. Validation is that check, in which LGE asks the provider whether the key works and has credit left.

You may fill in more than one provider's section. LGE then tries your default first and the other two after it, in the fixed order Anthropic, OpenAI, and Google Gemini with your default removed. Falling back means trying the next provider when one cannot answer.

<!-- SHOT: ai-assistant-provider-setup -->

### Step 4. Open the Assistant tab

Choose **View > AI Assistant** (Cmd-Shift-A). The Inspector opens on the right of your main window with its **Assistant** tab selected. The assistant is a tab in the Inspector rather than a separate window, so it stays beside your data and moves and resizes with the Inspector. Its header carries the title, a status line, a **Data sent…** button, and a **Clear** button.

The tab greets you with a short welcome message and a column of buttons, each holding a suggested question written against whatever is currently loaded. With the HG002 chromosome 20 slice open, six of the buttons read "Data overview", "Explore current view", "Search for a gene", "Variant statistics", "Find related research", and "Chromosome guide". PubMed, which the research button searches, is the free index of biomedical literature that the National Library of Medicine maintains. Click a button to send its question rather than typing. With no bundle loaded there is a single suggestion, which asks for step-by-step instructions on loading a bundle.

### Step 5. Read what would be sent, before you send it

Click **Data sent…** in the header. A popover opens showing exactly what a request would carry and which companies could receive it. Opening the popover sends nothing, and nothing leaves your machine while you read it.

The preview names the fallback order and states that only providers whose keys passed the check in step 3 are used. It also carries one warning worth reading twice. A single question can reach two companies, because a request that fails at the first provider may already have arrived there before the second one receives the fallback. The preview then prints the current context in full, so you can see the bundle name, the organism, and the region that would go out. Read it once before your first question and again whenever you switch to data you would rather not send anywhere.

### Step 6. Ask a question about the loaded dataset

Click the field at the bottom of the tab, which reads "Ask about your genome data...", type a question, and press Return. A spinning indicator appears while the provider works, usually for a few seconds and sometimes for up to a minute on a long question. LGE gives up after 150 seconds and reports the failure, so a stuck indicator resolves itself rather than needing a restart.

A plain question about the demo project would be "How many variants are in the HG002 chromosome 20 slice, and which chromosomes does it contain?" Because the assistant reads your selection, "What are the variants I have selected?" works too, once you have clicked a row in the Variants tab of the table drawer. [Reading the Variant Browser](../05-variants/02-reading-the-variant-browser.md) covers selecting rows.

The reply arrives as a message in the tab with a copy button on it, which turns to a checkmark for a moment after you click it. This appendix quotes no answer text, because the reply comes from a model outside LGE and differs between providers, between models, and between two runs of the same question.

Ask one question at a time. While a request is in flight the assistant declines a second with "Please wait for the current request to complete."

### Step 7. Clear the conversation when you change datasets

Click **Clear** in the header. Every message disappears, the welcome message returns, and the suggested questions are rebuilt against whatever is loaded now. Clearing touches only the tab. It writes nothing to your project and deletes nothing from it, and it does not unsend anything that already went to a provider. Clear whenever you move to a different bundle, so that the assistant is not reasoning from an out-of-date conversation about the previous one.

## Settings

Every control below lives in **Settings > AI Services**. The **Restore Defaults** button at the foot of the tab returns all nine AI settings to the values described here, including turning the enable toggle back off, while leaving your keys in the Keychain untouched.

**`Enable AI-powered search`.** Turns the AI Assistant on and adds its tab to the Inspector. The default is off, so a fresh install sends nothing anywhere until you decide otherwise. Turn it on once you have a key to use, and turn it back off whenever you are working on data you do not want leaving the machine. This setting has no command-line flag.

**Default provider:.** Chooses which of the three companies is tried first. The options are "Anthropic Claude", "OpenAI", and "Google Gemini". The default is "Anthropic Claude". Change it when your account or your lab's agreement is with one of the other two. The choice is a preference rather than a restriction, because LGE tries the other two after it in a fixed order. Choose "OpenAI" as your default, for example, and the resulting order is OpenAI, then Anthropic, then Google Gemini. A provider whose key field is empty is skipped before any request is made, and one whose key failed the check described in step 3 is dropped too, so a second configured provider can answer when the first cannot. This setting has no command-line flag.

**API Key.** Holds your credential for the provider whose section it appears in, and there is one such field under **Anthropic**, **OpenAI**, and **Google Gemini**. There is no default and each field starts empty. Fill in the one for your default provider, and fill in a second only if you want the fallback described above to have somewhere to go. LGE writes what you type into the macOS Keychain, so it survives a restart and never enters your project folder. This setting has no command-line flag.

**Model:.** Chooses which specific model at that company answers, and each of the three provider sections has its own picker. The default in each section is the entry marked Recommended, which is Claude Sonnet 4.6 for Anthropic, GPT-5.5 for OpenAI, and Gemini 3.5 Flash for Google Gemini. Those three are chosen because each balances speed against quality for a chat panel, and the recommended entry is the right choice unless your provider tells you otherwise. If the picker ever shows your saved value as a Custom entry, your provider has retired that model, and the fix is to pick a listed entry instead. This setting has no command-line flag.

**Use Azure AI-hosted endpoint.** Sends the OpenAI requests to a model your organisation has deployed on Microsoft's Azure cloud rather than to OpenAI directly, which is how a lab with a Microsoft agreement uses this assistant without an OpenAI account of its own. Skip this setting and the two below it unless an administrator has told you to use them. The default is off. Turn it on only when somebody has given you an address and a deployment name, and fill in the two fields below it before you do. This setting has no command-line flag.

**Endpoint.** Holds the web address your Azure administrator gives you, in the shape shown as placeholder text, `https://example.openai.azure.com`. There is no default and the field starts empty. Fill it in with that address, and leave it alone otherwise, because it has no effect while the toggle above is off. This setting has no command-line flag.

**Deployment.** Holds the deployment name your Azure administrator also gives you, which is a label your organisation chose when it published the model and is not always the model's own name. There is no default and the field starts empty, with `gpt-5-mini` shown as placeholder text to indicate the shape. Fill it in from the same source as the address, and change it when your administrator publishes a new deployment. This setting has no command-line flag.

<!-- SHOT: ai-assistant-azure-endpoint -->

**Clear All Keys.** Removes all three provider keys from the Keychain at once. Click it when you are handing the machine on, when a key has been exposed somewhere it should not be, such as pasted into a shared document or a chat message, or when you want to be certain nothing can be sent. LGE asks first, with a dialog headed "Clear All API Keys?" whose text reads "This will remove the three AI provider keys from Keychain. You will need to re-enter them to use AI features." There is no undo, and you re-enter the keys by typing them again. This setting has no command-line flag.

## Reading the results

The reply is one message bubble in the Assistant tab with a copy button on it. What arrives is prose, and its usefulness depends less on the wording than on whether it was grounded, meaning based on a real check of your data rather than on the model's own recollection. The assistant gives you two ways to tell.

The first is the status line in the header, which reports what the assistant is doing while it works, with text such as "Searching genes...", "Reading variant table...", or "Listing chromosomes...". A question the assistant answered by consulting your data will show one of those before the reply appears.

The second is the reply itself. An answer that names your bundle, your chromosome, and counts that match the Variants tab of the table drawer was grounded. That drawer opens by itself whenever the loaded bundle holds an annotation or variant track, so with the HG002 chromosome 20 slice open it is already at the bottom of the viewport. An answer that describes a gene in general terms without ever naming anything from your project probably was not grounded, and is worth asking again more specifically.

The assistant can also move your view without being asked twice, which is the only change it can make to anything in LGE. Two of its lookups do that. Here is the full set of lookups it can run.

- Search genes, search variants, and report the details of one named gene.
- Report variant statistics, and read the selected or visible rows of the Variants and Samples tables.
- Report what the viewport is currently showing.
- List the chromosomes or contigs in the loaded reference with their sizes, a contig being one continuous stretch of assembled sequence.
- Move the view to a gene, or move it to a region you name. These two are the ones that change something.

The assistant works in rounds, running lookups and reading the answers before it replies, and it stops after eight rounds. A single clear question usually finishes in one or two, so the limit only bites on a question that asked for several things at once. The limit is not adjustable.

Two replies are the app talking rather than the model, and both are worth recognising on sight. "No configured AI provider has a valid API key with available credits." means the feature is on but no key passed the check, which is a settings problem rather than a question problem. "I reached the maximum analysis steps without a final text response. Please try again with a narrower query, fewer requested actions, or a different AI provider." means the assistant used up those eight rounds without arriving at an answer. Split such a question into parts and ask them separately.

### Wet-lab follow-ups

The assistant also volunteers wet-lab follow-ups when a gene, variant, or region comes up, suggesting candidate assays and reagents. You cannot turn this behaviour off, and it appears only when your question raises one of those subjects. It reads the loaded organism first and shapes that advice accordingly, with separate guidance for rhesus macaque, human, and mouse datasets and a general species-aware form for everything else. On a macaque dataset it will name macaque-compatible antibody clones as examples, a clone being one specific commercial antibody product line, and tell you to check that the clone binds the part of the protein you care about.

Treat every reagent it names as a lead to confirm against the vendor's datasheet and current literature, never as a validated pick.

## What good looks like

Four checks separate a reply you can act on from one you should set aside, and they take less time to run than the question took to answer.

Check that the numbers match the app. If the assistant reports a variant count, read the Variants tab of the table drawer at the bottom of the viewport and compare. The app's own count is the correct one, so a mismatch probably means the reply was written rather than looked up.

Check that the answer names your data. A grounded reply refers to your bundle by name, your organism, and your coordinates. A reply that could have been written without ever seeing your project probably was written that way.

Check the context preview before sending anything sensitive. **Data sent…** shows the bundle and sample names that would travel to an outside company, and reading it once is the only way to know what a question actually discloses.

Check that nothing changed. The assistant edits no files, runs no workflow, imports and deletes no bundles, and writes nothing into your project's provenance. If a bundle looks different after a conversation, the change came from somewhere else, and the Operations panel will say from where.

## On the command line

This section is optional, and for this appendix it is short. If you do your work in the LGE window, everything above is complete without it.

The AI Assistant has no command-line counterpart, so there is no headless procedure to give here. Nothing in `lungfish-cli` opens a chat session or sends a question to a provider. Two commands have names that suggest otherwise and do something else entirely. `lungfish-cli search` looks for a text pattern in a FASTA file and writes the hits as a BED file, which is a plain text list of positions, with no model involved. `lungfish-cli universal-search` looks through an index of one project's datasets and analyses using a field syntax rather than a plain-English question. One unrelated command does reach an AI provider. `lungfish-cli genotype ai-haplotyping` asks a model to propose or refine haplotype assignments on a `.lungfishgenotype` bundle, the file the genotyping chapters produce, and it takes its own `--provider`, `--model`, `--azure-openai-endpoint`, and `--azure-openai-deployment` flags. It belongs to the genotyping chapters rather than to this appendix.

## Next

If you have no provider account and do not plan to get one, nothing in this appendix applies to you, and every other chapter of this manual works without it. Return to [The Lungfish Genome Explorer Project](../01-foundations/06-the-lungfish-project.md) for how projects and their provenance records are organised.
