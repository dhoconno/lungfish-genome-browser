# Reader report: Oxford Nanopore Runs

Reader 3. Pre-med student, English is my second language. I have taken genetics. I have never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "The instrument's control software is called" | "control software" is not a phrase I know. I did not know if it runs on the machine or on my laptop. | Say it is the program on the sequencer's own computer. |
| What it is, "MinKNOW turns the raw electrical" | I do not understand how electricity becomes a base. I read this three times. | One sentence saying DNA passes through a tiny hole and each base changes the current in its own way. |
| What it is, "the raw electrical signal from each" | "pore" is used before it is explained. I guessed it is a hole but I was not sure. | Gloss "pore" at first use like the other terms. |
| What it is, "holding the reads that cleared" | "cleared its own quality threshold" was hard. I did not know what the threshold is or who sets it. | Say which reads are kept and whether I can change the cutoff. |
| What it is, "It writes a stream of numbered" | "chunks" felt informal and I was not sure it is a technical term. Is a chunk a file? | Say plainly that each chunk is one file holding part of the reads. |
| What it is, "attached to each sample's molecules during" | "library preparation" is never explained here. In my class "library" meant something else. | Gloss library preparation at first use in this chapter. |
| Why you would do this, "The HG002 long reads used" | The numbers 263 and 39,647 arrived before I knew if that spread is normal or a problem. | Say whether such a wide spread is expected in every nanopore run. |
| Why you would do this, "The HG002 long reads average" | I could not check the arithmetic from 7.9 to one in six, and I did not know if 7.9 is bad. | Show the conversion in one short line and say what Phred value would be good here. |
| Why you would do this, "You read the pile of" | I did not know how many reads I need for the errors to cancel out. | State the rough coverage depth at which this works. |
| Why you would do this, "That high copy number is" | I did not know that 262 times is the same idea as depth, or whether more is always better. | Gloss coverage the first time a fold number appears. |
| Before you start, "On the GitHub page, click" | I could not do this from the text. I did not know which three folders to make or how to make them on my Mac. | Name the three folders explicitly in the order I must create them. |
| Before you start, "Importing a run folder needs" | I do not know what a plugin pack or Docker Desktop is, so I could not tell if I was missing something. | Say only that no extra installation is needed. |
| Before you start, "A real 24-barcode run takes" | The Operations Panel was never introduced and I did not know how to open it. | Say which menu opens it, or link to the chapter that does. |
| Procedure step 2, "Click the Sequencing Reads tab" | I selected the file first and nothing happened. I did not understand I must click the folder once, not open it. | Say to click the folder once so its name shows, then click Open. |
| Procedure step 4, "Leave Apply processing recipe after" | I could not find this checkbox, and the screenshot is only a placeholder comment, not a picture. | A picture, or say where on the sheet the checkbox sits. |
| When the run needs demultiplexing, "Or the library may carry" | Two barcodes on one read confused me. I could not picture the arrangement. | A small diagram, or say the outer one is read first and the inner one sits closer to my DNA. |
| When the run needs demultiplexing, "It handles libraries built with" | I do not know what CS1 and CS2 are or why they are called fixed. | Say they are two known primer sequences added in the lab that flank the barcode. |
| Checking barcodes before you commit, "That is what the barcode" | I have never opened a terminal, so I did not know whether I can follow this advice at all. | Say plainly that this check is optional for window users. |
| Settings, "The first four settings below" | I could not tell which four. I counted the bold headings and lost my place. | Number them, or name the four settings. |
| Settings, Barcode Sheet, "The Fluidigm recipe needs a" | I did not know how to make such a file or what format it must be. | Say the file type and give one example row. |
| Settings, Demux Folder, "It starts as a name" | I did not understand what happens to a character that is replaced, or what replaces it. | Say which character replaces them. |
| Settings, Built-In Kit, "Twenty kits are offered, and" | Ten names that look almost the same. I could not tell which matches the box my lab used. | Say where the kit name is printed on the kit box or protocol. |
| Settings, Engine, "Switch to Exact Bare Barcode" | I did not know when barcodes sit at unpredictable positions, so I could not judge if this is my case. | Give one concrete library type where this happens. |
| Settings, 5' Distance, "It defaults to 0, meaning" | I know 5' and 3' from class, but a distance of 0 sounded like the setting is switched off. | Say 0 means no gap is allowed before the barcode. |
| Settings, Error Rate, "Sets the fraction of barcode" | 0.15 times 20 is exactly 3, so I could not tell if it rounds up or down for other barcode lengths. | Say whether the allowed count rounds down. |
| Settings, Output Strategy, "It defaults to Per Input" | "multi-select" and "the safe reading" together made no sense to me. I read it twice. | Say it keeps results separate when you selected more than one bundle. |
| Reading the results, "Click the new bundle in" | I do not know what a sparkline is. | Gloss sparkline as a very small chart. |
| Reading the results, "Input reads: 927" | The import said 950 reads but the demultiplex says 927. I could not find where 23 reads went. | Explain the difference between 950 and 927 where it first appears. |
| Reading the results, "Zero percent assigned is what" | I could not tell the two causes apart from the output alone, and no fix was given. | Say what a scout output looks like in the wrong-kit case. |
| What good looks like, "The base-count field the run-folder" | I did not know if this wrong number is a bug I should report or normal behaviour I must live with. | Say whether this will be fixed or is expected. |
| What good looks like, "Samples pooled on one flow" | "within a few-fold" is vague. I did not know if 5 times apart is acceptable. | Give a number, for example within 10 times. |
| On the command line, "The scout and demultiplex commands" | I did not know what a .lungfish project folder is or where it sits on disk. | Say the project folder you chose in New Project carries this name. |
| On the command line, "A backslash at the end" | I could not see the backslash clearly in the code block and did not know if I have to type it. | Say the backslash is only needed if you break the line yourself. |
| On the command line, "lungfish-cli fastq scout Imports/HG002.chrM.ont.fastq.gz" | This filename never appeared before. The chapter imported HG002_chrM_pass_barcode01_0.fastq.gz. | Use the same filename as the fixture, or say why it changed. |
| On the command line, "--threads is recorded for provenance" | "provenance" is a word I had to look up, and I still did not see why record a setting that does nothing. | Replace with a plain phrase such as recorded in the run record. |
| What this chapter does not cover, "POD5 and FAST5 files hold" | Two new file names at the very end with no context. I did not know if I have them or need them. | Say these files stay on the sequencer and most users never touch them. |
| Next, "Nanopore reads need it more" | This was the first time the direction of a read was explained, and it came in the last sentence of the chapter. | Mention strand direction earlier, where reads are first described. |

One thing I learned. A nanopore run arrives as many small files inside barcode folders, and the importer joins each folder into one sample for me.

One thing I still could not do. Rebuild the three-level folder structure from GitHub on my own computer, so I never got as far as importing anything.

The sentence I liked most. "You do not read individual nanopore bases as truth."
