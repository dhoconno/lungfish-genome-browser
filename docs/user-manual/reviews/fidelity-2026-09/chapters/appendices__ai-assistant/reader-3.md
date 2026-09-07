# Reader 3 report on `appendices/ai-assistant.md`

Reader: pre-med student, English is my second language. Strong on biology
words from textbooks. Slow with idioms and long sentences. I have never
opened a terminal.

| Location | Issue | Suggested fix |
| --- | --- | --- |
| What it is, "the state of the active viewer" | "Active viewer" is never explained. I do not know if this is a window, a tab, or a panel. It is used again in Before you start. | Gloss it at first use as the viewport showing the currently selected bundle. |
| What it is, "the loaded bundle, the organism, the region" | "Bundle" is used here for the first time and never defined in this chapter. I met this word only in the sidebar of the app screenshot. | Gloss "bundle" at first use as a folder of files LGE treats as one dataset. |
| What it is, "the rows you have selected in the variant or sample tables" | I do not know where the variant or sample tables are. The Reading the results section later says "the Variants tab of the table drawer", but that is many paragraphs away. | Name the table drawer here at first mention. |
| What it is, "Behind the scenes the panel gathers" | "Behind the scenes" is a theatre idiom. I had to stop and think whether something is hidden from me on purpose. | Replace with a plain phrase such as "automatically". |
| What it is, "Two consequences follow from that arrangement" | Long sentence with "and they matter more than any feature described later in this appendix" attached. I read it twice to find the main clause. | Split into two sentences. |
| What it is, "So what should you do with this?" | A question addressed to me in the middle of an explanation made me stop, because I thought I was supposed to answer something. | Make it a statement. |
| What it is, "confirm anything you intend to publish against the viewport" | "Against" here means "by comparing with", but my first reading was "in opposition to". This is a hard preposition for me. | Use "by checking it in the viewport, the Operations panel, or the command line". |
| What it is, "the Operations panel" | Named as a place to confirm results, but never described here and there is no cross-reference. | Add one clause saying what the Operations panel shows. |
| Why you would do this, "is the case where the panel earns its keep" | "Earns its keep" is an idiom. I could guess from context but it cost me time. | Replace with "is where the panel is most useful". |
| Why you would do this, "a human chromosome 20 slice and an HBB gene record" | "Slice" is used as a noun for part of a chromosome. I know slice from a knife or a microscope section. I was not sure if this is a physical section or a region of sequence. | Say "a region of human chromosome 20". |
| Why you would do this, "three read bundles under `Imports/`, and five analysis outputs under `Analyses/`" | I cannot judge these numbers. Three and five mean nothing to me because I do not know how large a normal project is. | Say these are the contents of the demo project, not a target size. |
| Why you would do this, "a SPAdes assembly of HG002 mitochondrial reads and a Kraken 2 classification" | SPAdes, HG002, and Kraken 2 all appear with no gloss. I know what an assembly is from my textbook but not what HG002 is. | Gloss each at first use, or say they are tool and sample names covered in other chapters. |
| Why you would do this, "questions the sidebar cannot answer on its own" | "Sidebar" is not introduced. I do not know which edge of the window it is on. | Gloss at first use. |
| Why you would do this, "Which chromosomes ... and which of those variants fall inside a named gene." | Three questions written as one sentence ending in a period, not a question mark. I read it twice trying to find where the sentence broke. | Make them three separate questions with question marks, or a short list. |
| Why you would do this, "rather than a judgement about biology" | I did not understand what makes a lookup different from a judgement until much later, in Reading the results. | Give one concrete example of each here. |
| Before you start, "choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window" | I could do this, but I could not tell where the Welcome window comes from if it is not showing. | Say how to reopen the Welcome window. |
| Before you start, "You also need an account with one of three companies, and a key from it." | I could not perform this step. The chapter never says how to get an account or where the key page is on each company's site. Twenty minutes is budgeted mostly for this and there is no instruction for it. | Add one line per provider naming the page where a key is created, or say explicitly that the provider's own documentation covers it. |
| Before you start, "Those accounts are paid, they are yours rather than the project's, and every question you ask spends your own credit." | I could not judge cost. As a student I need to know if one question costs cents or dollars before I create a paid account. | Give an order-of-magnitude cost per question, or say the cost depends on provider and model and link to their pricing. |
| Before you start, "no analysis in LGE requires an AI provider" | Good to know, but I only found this at the end of a long paragraph. It changed whether I would continue reading. | Move this reassurance to the start of the paragraph. |
| Step 1, "from the application menu, the one bearing the app's name at the left of the menu bar" | "Bearing" is a formal verb I had to look up. | Use "the menu named after the app". |
| Step 2, "It is off when LGE is installed" | I could not tell whether this means off by default forever, or off only on the very first launch. | Say "off by default on a new installation". |
| Step 3, "`sk-ant-...` for Anthropic, `sk-...` for OpenAI, and `AIza...` for Google Gemini" | I did not know these are examples of shape, not text I should type. The word "placeholder" is used but not glossed. | Gloss "placeholder text" as grey example text that disappears when you type. |
| Step 3, "the only place LGE has anywhere to put it safely" | I read this sentence three times. The word order "has anywhere to put it" is very hard for me. | Rewrite as "the only place LGE can store it safely". |
| Step 3, "so handing a colleague a project hands them no credential of yours" | Double use of "hand" plus a negative object. I had to read it twice to be sure my key is not shared. | Rewrite as "so a colleague who receives your project does not receive your key". |
| Step 3, "A small indicator sits to the left of each key field and reports what LGE knows about that key" | I could not perform this check. The text never says what the indicator looks like or what its states mean, so I do not know what I am watching for. | List the indicator states and what each one means. |
| Step 3, "the panel will use them in the order described under Settings below" | A forward reference. I stopped here and scrolled down, then lost my place. | State the order here in one sentence. |
| Step 4, "It is a floating panel, meaning it stays in front of the main window" | Good gloss, but the sentence then adds two more clauses about clicking behind it and remembering position. Very long. | Split into two sentences. |
| Step 4, "the suggestions include a data overview, a look at the current view, a gene search, a variant statistics breakdown, a PubMed literature search, and a chromosome guide" | Six items in one sentence. I lost track by the fourth. Also PubMed is not glossed. | Use a short list and gloss PubMed. |
| Step 5, "and it sends nothing while you read it" | I trusted this, but the next clause says a failed request "may already have reached one provider before another receives the fallback", which sounds like the opposite. I could not reconcile the two. | Separate the preview behaviour from the fallback warning into two sentences. |
| Step 5, "names the fallback order" | "Fallback" is used here before it is explained in Settings. | Gloss "fallback" at first use. |
| Step 6, "A spinning indicator appears while the provider works." | I could not judge how long is normal. If it spins for one minute should I worry? | Give a rough expected time, or say what to do if it never stops. |
| Step 6, "Because the panel reads your selection" | I do not know how to select variant rows, and the chapter never shows me. The example question depends on having a selection. | Add one clause on how to select rows, or cross-reference the chapter that covers it. |
| Step 6, "differs between providers, between models, and between two askings of the same question" | "Two askings" is unusual English and it made me stop. | Use "and even between two runs of the same question". |
| Step 7, "so that the assistant is not reasoning from a stale conversation" | "Stale" is a bread word for me. In this sentence I guessed "old" but was not sure. | Use "out-of-date". |
| Settings, "**`Enable AI-powered search`.**" | The setting names are formatted three different ways in this section, some in code marks, some in bold, some with a trailing colon like "Default provider:." That double punctuation confused me about whether the colon is part of the label. | Use one consistent format for setting names. |
| Settings, Default provider, "the full order is your default followed by Anthropic, OpenAI, and Google Gemini with the default removed from the list" | Very hard sentence. I had to work an example on paper to understand that choosing OpenAI gives OpenAI, then Anthropic, then Google Gemini. | Give one worked example instead of the rule. |
| Settings, Default provider, "one whose key fails validation or has no credit is dropped too" | I do not know what "validation" means here or how I would see that it failed. | Say what the indicator shows when validation fails. |
| Settings, Model, "Anthropic offers four options ... OpenAI offers twelve and marks GPT-5.5 as recommended, and Google Gemini offers eight" | I cannot judge these counts. Four, twelve, and eight tell me nothing about which to choose beyond the recommendation. | Say the recommended default is right unless you have a reason, and drop the counts. |
| Settings, Model, "your provider retires the default and the picker shows your saved value as a Custom entry" | I could not tell whether a Custom entry is a problem I must fix or is fine. | Say what to do when a Custom entry appears. |
| Settings, Use Azure AI-hosted endpoint, "Azure AI or Azure OpenAI" | Two similar names, neither glossed. I do not know if they are the same thing. | Gloss Azure once and say why the two names appear. |
| Settings, Use Azure AI-hosted endpoint, "`lungfish-cli genotype ai-haplotyping` accepts the same information" | I have never opened a terminal. This appears inside a Settings entry, not in the optional command-line section, so I did not know I could skip it. | Move the command-line note into the command-line section, or mark it as optional here. |
| Settings, Endpoint, "the web address of your Azure resource" | "Resource" is used in a cloud-computing sense I do not know. | Gloss "resource" or say "the address your administrator gives you". |
| Settings, Clear All Keys, "It is not a stored value and so has no default." | I read this twice. It is a button, so I did not expect a sentence about defaults at all. | Drop this sentence for buttons. |
| Reading the results, "grounded in a lookup or written from the model's own recollection" | "Grounded" and "recollection" are both used in a special sense. This is the most important idea in the section and I was not certain I understood it. | Gloss "grounded" as based on a real check of your data. |
| Reading the results, "counts that match the Variants tab of the table drawer was grounded" | Long sentence starting "An answer that names your bundle, your chromosome, and counts that ...". I had to read twice to find the verb. | Split into two sentences. |
| Reading the results, "Eleven lookups are available ... Two of those move the view ... The other nine only read." | Eleven items are listed inside one long sentence with no list. I could not count them to check the eleven, nor tell which two move the view. | Use a short list and mark the two that move the view. |
| Reading the results, "its budget of eight lookup rounds" | I cannot judge eight. I do not know if that is generous or tight, or whether I can change it. | Say whether the limit is adjustable and what a typical question uses. |
| Reading the results, "candidate assays and reagents ... macaque-compatible antibody clones ... check clone and epitope compatibility" | I know antibody and epitope from immunology class, but "clone" in this sense is not the cloning I learned, and "clone and epitope compatibility" is dense. | Gloss "clone" as a specific named antibody product line. |
| What good looks like, "The app's own count is the arbiter and the assistant's is not" | "Arbiter" is a formal word I had to look up. | Use "the app's count is correct". |
| What good looks like, "a mismatch means the reply was written rather than looked up" | This is stated as certain, but earlier the chapter said only "probably". I could not tell how confident to be. | Match the hedging used elsewhere. |
| On the command line, "The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application." | The gloss for headless is good, but the sentence says "the whole procedure runs headless" and then the section immediately says the panel has no command-line counterpart. I read the section twice trying to resolve the contradiction. | Remove or rewrite the headless sentence for this appendix. |
| On the command line, "an IUPAC ambiguity motif, or a regular expression" | Both unglossed. I have seen IUPAC codes in a textbook table but not "ambiguity motif", and "regular expression" is completely new. | Gloss both, or say this section is safe to skip. |
| On the command line, "its query language is a field syntax such as `type:fastq_dataset`" | "Field syntax" is not glossed and I could not tell what I would type. | Gloss or drop the example. |
| Next, "for how they and their provenance records are organised" | "They" refers back to "projects" across a link, and "provenance" was glossed far earlier in What it is. I had to scroll back. | Repeat the word "projects" instead of "they". |

Three closing lines.

The one thing I learned. My question and my sample names leave my computer
and go to an outside company, and nothing the assistant says is recorded as
evidence in my project.

The one thing I still could not do. Get an API key. The chapter tells me I
need an account with Anthropic, OpenAI, or Google Gemini and that it costs
my own money, but never tells me where to create one or roughly what a
question costs, so I could not finish Step 3.

The sentence I liked most. "LGE ships no model of its own and runs none for
you."
