#include <portaudio.h>
#include <lame/lame.h>

#include <cstdlib>
#include <iostream>

/**
 * @file
 */
/**
 * \mainpage
 *
 * Record 16-bit 44.1kHz audio from the default line in and
 * save the stream to VBR mp3 in real time.
 *
 * Records to stdout, invoke like this (posix systems).
 *
 * $ ./recmp3 > out.mp3
 *
 * Hit CTRL-C to stop recording. It'll drop around a second
 * of data so wait before you stop the recording.
 *
 * Requires portaudio and lame.
 *
 * This program is in the public domain and provides no
 * warranty or guarantees. It was originally conceived and
 * written by
 *
 * ken_smith_t<gmail> kgsmith;
 */

/**
 * Configure the stream.
 */
struct constants_t
{
    enum {
        sample_rate = 48000, ///< Hz
        num_channels = 1, ///< 1 is monaural
        num_seconds = 1, ///< number of seconds to record before encoding
        num_samples = sample_rate * num_seconds
    };
};

/**
 * Represent a chunk of 16-bit audio data. This is a single unit of
 * audio currency.
 */
struct pcm_segment_t
{
    pcm_segment_t()
        :
            buffer(new std::int16_t[constants_t::num_samples])
    {
    }

    ~pcm_segment_t()
    {
        delete [] buffer;
    }

    std::int16_t * buffer;
};

/**
 * Manage portaudio state and dispense audio clips.
 */
struct mono_line_recorder_t
{
    mono_line_recorder_t()
    {
        Pa_Initialize();
        Pa_OpenDefaultStream(
            &stream_,
            1,
            0,
            paInt16,
            constants_t::sample_rate,
            paFramesPerBufferUnspecified,
            NULL,
            NULL
        );
        Pa_StartStream(stream_);
    }

    ~mono_line_recorder_t()
    {
        Pa_Terminate();
    }

    /**
     * Record a chunk of audio data
     * @return the chunk
     */
    pcm_segment_t const & record()
    {
        Pa_ReadStream(
            stream_,
            pcm_segment_.buffer,
            constants_t::num_samples
        );

        return pcm_segment_;
    }

private:
    pcm_segment_t pcm_segment_;
    PaStream* stream_;
};

/**
 * Manage lame state and encode audio segments to VBR MP3.
 */
struct mono_vbr_mp3_encoder_t
{
    mono_vbr_mp3_encoder_t()
        :
            lame_(lame_init())
    {
        lame_set_in_samplerate(lame_, constants_t::sample_rate);
        lame_set_num_channels(lame_, constants_t::num_channels);
        lame_set_VBR(lame_, vbr_default);
        lame_init_params(lame_);
    }

    ~mono_vbr_mp3_encoder_t()
    {
        lame_close(lame_);
    }

    /**
     * Encode a chunk of audio data.
     * @param [in] segment the chunk
     */
    void encode(pcm_segment_t const & segment)
    {
        int encres = lame_encode_buffer(
            lame_,
            segment.buffer,
            NULL,
            constants_t::num_samples,
            buffer_,
            buffer_len_
        );

        if (encres > 0)
        {
            std::string const mp3data((char*)buffer_, encres);
            (std::cout << mp3data).flush();
        }
    }
private:
    static int const buffer_len_ =
        1.25 * constants_t::num_samples + 7200;
    lame_t lame_;
    std::uint8_t buffer_[buffer_len_];
};

int main()
{
    mono_line_recorder_t recorder;
    mono_vbr_mp3_encoder_t encoder;

    while(true)
    {
        encoder.encode(recorder.record());
    }

    return 0;
}
