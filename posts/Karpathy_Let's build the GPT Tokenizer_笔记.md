> 源：https://www.youtube.com/watch?v=zduSFxRajkE&feature=youtu.be

- Tokenizer 用于将自然语言转换为token id（数字）
- Embedding 用于将 token id 转换为向量
- 与 LLM 类似，Tokenizer 本身也存在训练、推理过程
- Tokenizer 由编码和解码两部分组成
- GPT2由于无法很好处理连续空格，生成的 token 偏多，导致它对 python 的能力较差。GPT4则解决了这个问题
- Tokenizer基本的思路是“嵌入表”
- 在编码部分，可以按照排列的出现频率，进行文本压缩。例如某个字母组合多次出现，则可以将它编码成一个token；在解码时，则反向操作
- GPT2 的 BPE tokenizer 词表大小是 50257，即 token id 取值范围是 0~50256，可以分为3类Token：
	- 256 个基础byte token。其原理是，任意文本都可以转换为UTF-8 bytes，每个byte值0~255都有一个基础token。因此一定可以表示任意文本。
	- 50000 个 BPE merge token。保存的是出现频率高的组合，例如"the", "ing"等。对于“空格”需要特别关注，空格通常作为token的起始而非结尾，例如 "the" 和 "Ġthe"(Ġ表示空格) 是两个不同的token。
	- 1 个特殊token。表示文本结束、文档分隔的  <|endoftext|>。
