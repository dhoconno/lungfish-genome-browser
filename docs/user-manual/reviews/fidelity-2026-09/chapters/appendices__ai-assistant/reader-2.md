# Reader 2 report, appendices/ai-assistant

Persona. A senior who has spent two years pipetting in a wet lab, knows library
prep and PCR well, has never done any data analysis, and has never opened a
terminal.

| Location | Issue | Suggested fix |
| --- | --- | --- |
| What it is, "the state of the active viewer" | I do not know what a viewer is here. Is it the window, a tab, a panel? Nothing has told me yet. | Gloss viewer at first use as the part of the LGE window that draws the data. |
| What it is, "meaning the loaded bundle, the organism" | Bundle is used as if I already know it. I make libraries, not bundles. I cannot picture what one is. | Gloss bundle at first use as one dataset plus its index files, stored as a folder. |
| What it is, "the rows you have selected in the variant or sample tables" | I have never seen these tables and do not know where they live. Two sections later they turn out to be in a table drawer, which is never introduced. | Name where the tables live at first use. |
| What it is, "you give LGE the API key" | I understand the sentence but not how I would get a key. The text says I hold an account and gives no path from zero to a key. | Say the key comes from the provider's own website after signing up, and that LGE cannot make one. |
| What it is, "your project's provenance, the record of which tool" | The gloss helps, but I still do not know where I would look at provenance or why a missing record hurts me. | Add one clause saying where provenance is shown. |
| What it is, "confirm anything you intend to publish against the viewport, the Operations panel, or the command line" | Three places I have never heard of, offered as the fix. Viewport arrives unglossed here and again later. Command line is the thing I have never opened. | Gloss viewport once, and drop the command line from this list for a reader who does not use it. |
| Why you would do this, "The demo project holds a mixed collection" | I do not know how to get the demo project. It is named as if it is already on my machine, and no step says to download or open it. | Say in one sentence where the demo project comes from. |
| Why you would do this, "a human chromosome 20 slice and an HBB gene record under `Reference Sequences/`" | Slice is vague. A slice of what size? And I cannot tell whether these paths are folders I will see or internal jargon. | Say the slice is a region of chromosome 20 and give its length. |
| Why you would do this, "five analysis outputs under `Analyses/` including a SPAdes assembly of HG002 mitochondrial reads and a Kraken 2 classification" | SPAdes, HG002, and Kraken 2 all arrive unexplained in one sentence. I had to read it twice and still do not know what a classification output is. | Gloss each of the three, or cut the detail to the two items the appendix actually uses. |
| Why you would do this, "how many variants sit in its variant track" | Track is new. I know what a variant is from genetics, but not what a track is in this app. | Gloss track at first use. |
| Why you would do this, "each one is a lookup against data already loaded rather than a judgement about biology" | Good sentence, but I cannot yet tell which of my own questions would be a lookup. Nothing gives me a test to apply. | Add one example of a question that is not a lookup. |
| Before you start, "choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder" | This is performable, but it conflicts with the previous section, which assumed the demo project. I do not know whether a brand new empty project is enough to follow the steps. | Say plainly that an empty new project will not show the suggested questions described later. |
| Before you start, "LGE supports Anthropic, OpenAI, and Google Gemini" | I cannot judge which to pick. No cost figure, no guidance, and I do not know what a typical question costs me. | Give a rough per-question cost or say costs are cents-scale. |
| Before you start, "Those accounts are paid" | Paid how much? A student with no budget cannot decide whether to continue. This is a number I cannot judge. | State the minimum spend needed to try this appendix. |
| Before you start, "Set aside about twenty minutes" | Helpful, but it clashes with the front matter, which says sixteen minutes of reading. I read both and could not reconcile them. | Say the twenty minutes includes account creation, separate from reading time. |
| Step 1, "Choose **Settings...** (Cmd-,) from the application menu, the one bearing the app's name" | Performable. I liked the description of which menu. No issue. | None. |
| Step 2, "It is off when LGE is installed" | Fine, but I could not tell whether turning it on by itself sends anything. The next sentence answers it, so I read the pair twice. | Merge the two sentences so the reassurance lands first. |
| Step 3, "Each provider's field shows the shape its keys take as grey placeholder text" | I do not know what placeholder text is versus a real value, so I might think a key is already entered. | Say the grey text disappears when you type. |
| Step 3, "the macOS Keychain, the system store that holds passwords" | The gloss is good. But nothing tells me how to check later that the key is really there, or how to change it. | Add one clause on returning to this field to replace a key. |
| Step 3, "A small indicator sits to the left of each key field and reports what LGE knows about that key, so watch it after you type" | This is the one step I could not perform. It never says what the indicator looks like or what any of its states mean, so watching it teaches me nothing. | List the indicator states and what each means. |
| Step 3, "the panel will use them in the order described under Settings below" | A forward reference in the middle of a procedure. I stopped and went hunting for the order. | State the order here in one clause. |
| Step 4, "It is a floating panel, meaning it stays in front of the main window" | Clear and glossed. No issue. | None. |
| Step 4, "the suggestions include a data overview, a look at the current view, a gene search, a variant statistics breakdown, a PubMed literature search, and a chromosome guide" | Six items in a run-on list I had to reread. Also I do not know what PubMed is doing in a genome app or whether that search leaves my machine too. | Split the list and say whether the PubMed suggestion sends data out. |
| Step 5, "Click **Data sent…** in the panel header" | Performable, and I liked that it sends nothing while I read. No issue. | None. |
| Step 5, "warns that a failed request may already have reached one provider before another receives the fallback" | I read this three times. It is the most important privacy sentence in the appendix and it is the hardest one to parse. | Rewrite as a short plain sentence about data possibly reaching two companies. |
| Step 6, "Because the panel reads your selection" | Nothing earlier told me how to select a variant row, so I cannot try the second example question. | Point to where row selection is described. |
| Step 6, "A spinning indicator appears while the provider works" | I do not know how long is normal. If it spins for a minute I cannot tell whether it is broken. | Give a typical wait in seconds. |
| Step 7, "so that the assistant is not reasoning from a stale conversation" | Understood, but nothing says whether Clear also stops what has already been sent to the company. I assumed it might. | Say plainly that clearing does not unsend anything. |
| Settings, "The **Restore Defaults** button ... while leaving your keys in the Keychain untouched" | Clear. No issue. | None. |
| Settings, Default provider, "so the full order is your default followed by Anthropic, OpenAI, and Google Gemini with the default removed from the list" | The hardest sentence in the chapter. I had to work the list out on paper to see that my default is not repeated. | Give the resulting order for one worked example. |
| Settings, Default provider, "one whose key fails validation or has no credit is dropped too" | Validation is used as a term without a gloss, and it is the same thing the Step 3 indicator was supposed to show me. | Gloss validation once and tie it to the indicator. |
| Settings, Model, "Anthropic offers four options ... OpenAI offers twelve ... Google Gemini offers eight" | Counts I cannot judge or act on. Twelve options with no guidance means I will pick blindly if I ever change it. | Cut the counts, or say the recommended entry is the right pick unless told otherwise. |
| Settings, Model, "each balances speed against quality" | I cannot judge this. No sense of how much slower a bigger model is, or what quality means for a lookup. | Give a rough time difference. |
| Settings, Model, "the picker shows your saved value as a Custom entry instead" | I do not know what a Custom entry is or what I should do when I see one. | Say what to do when a Custom entry appears. |
| Settings, Use Azure AI-hosted endpoint, "a model your organisation has deployed on Azure AI or Azure OpenAI" | Azure, endpoint, and deployment are three unglossed terms in one sentence. I have no idea whether this applies to my lab. | Add one line saying to skip this unless an administrator tells you otherwise. |
| Settings, Use Azure AI-hosted endpoint, "although `lungfish-cli genotype ai-haplotyping` accepts the same information" | A terminal command in the middle of a settings entry I am reading in the app. I do not use a terminal and it stopped me. | Move the flag note to the command-line section. |
| Settings, Endpoint, "Holds the web address of your Azure resource" | Resource is new here after endpoint and deployment. Three near-synonyms and I cannot keep them apart. | Use one term consistently. |
| Settings, Clear All Keys, "when a key has leaked" | Leaked is not explained, and nothing tells me how I would know. This is the scariest line in the chapter and the vaguest. | Give one concrete example of a leak, such as pasting a key into a shared document. |
| Reading the results, "whether it was grounded in a lookup or written from the model's own recollection" | Grounded is used as a technical term four more times and never glossed. I inferred it, which took a reread. | Gloss grounded at first use. |
| Reading the results, "counts that match the Variants tab of the table drawer" | The table drawer appears for the first time here and is never introduced. I do not know how to open it, so I cannot run this check. | Say how to open the table drawer, or link to where it is described. |
| Reading the results, "Eleven lookups are available to the assistant" | Eleven is stated, then the sentence lists capabilities in prose and I counted nine or ten depending on how I split them. Then the text says two move the view and nine only read. I could not reconcile the arithmetic. | Present the lookups as a short list so the count is checkable. |
| Reading the results, "its budget of eight lookup rounds" | A number I cannot judge or change. Nothing says whether eight is generous or tight for a normal question. | Say what a typical question uses. |
| Reading the results, "with separate guidance for rhesus macaque, human, and mouse datasets" | Fine. This is the part closest to my bench work and I would have liked more of it. | None. |
| Reading the results, "it will name macaque-compatible antibody clones as examples and tell you to check clone and epitope compatibility" | I know clones and epitopes from the bench, so this landed. But the warning to confirm against a datasheet is buried at the end of a long paragraph. | Set the confirm-against-the-datasheet warning on its own line. |
| What good looks like, "Four checks separate a reply you can act on" | Good framing. But the first check depends on the table drawer I still cannot open, so I can run only three of the four. | Fix the table drawer gap above and this check becomes performable. |
| What good looks like, "the Operations panel will say from where" | The Operations panel is named for the third time and still never introduced or located. | Gloss the Operations panel once at first mention. |
| On the command line, "The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application" | The gloss is good, and I was glad it says the section is optional. But then it turns out there is no command-line version at all, so the whole framing misled me. | Open the section by saying the panel has no command-line counterpart. |
| On the command line, "an IUPAC ambiguity motif, or a regular expression" | Two unglossed terms in a section I was told I could skip. I stopped anyway to see whether I needed them. | Cut the detail or gloss both. |
| On the command line, "`type:fastq_dataset`" | I cannot tell whether this is something I type or an example of a shape. Nothing around it tells me. | Label it as an example of the query shape. |
| Next, "Return to [the chapter on projects]" | Clear. No issue. | None. |

The one thing I learned. My question, my bundle names, and my sample names all
travel to an outside company under my own paid key, and nothing the assistant
says is recorded as part of my results.

The one thing I still could not do. Open the table drawer to check a variant
count against the assistant's answer, which is the first of the four checks the
chapter tells me to run.

The sentence I liked most. "An answer that describes a gene in general terms
without ever naming anything from your project probably was not, and is worth
asking again more specifically."
