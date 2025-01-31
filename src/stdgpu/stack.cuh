/*
 *  Copyright 2019 Patrick Stotko
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#ifndef STDGPU_STACK_H
#define STDGPU_STACK_H

#include <stdgpu/impl/platform_check.h>

/**
 * \addtogroup stack stack
 * \ingroup data_structures
 * @{
 */

/**
 * \file stdgpu/stack.cuh
 */

#include <stdgpu/cstddef.h>
#include <stdgpu/deque.cuh>
#include <stdgpu/platform.h>
#include <stdgpu/utility.h>

///////////////////////////////////////////////////////////

#include <stdgpu/stack_fwd>

///////////////////////////////////////////////////////////

namespace stdgpu
{

/**
 * \ingroup stack
 * \brief A generic container similar to std::stack on the GPU
 * \tparam T The type of the stored elements
 *
 * Differences to std::stack:
 *  - index_type instead of size_type
 *  - Manual allocation and destruction of container required
 *  - No guaranteed valid state when reaching capacity limit
 *  - Additional non-standard capacity functions full(), capacity(), and valid()
 *  - Several member functions missing
 */
template <typename T, typename ContainerT>
class stack
{
public:
    using container_type = ContainerT;                  /**< ContainerT */
    using value_type = typename ContainerT::value_type; /**< ContainerT::value_type */

    using index_type = typename ContainerT::index_type; /**< ContainerT::index_type */

    using reference = typename ContainerT::reference;             /**< ContainerT::reference */
    using const_reference = typename ContainerT::const_reference; /**< ContainerT::const_reference */

    /**
     * \brief Creates an object of this class on the GPU (device)
     * \param[in] size The size of managed array
     * \return A newly created object of this class allocated on the GPU (device)
     */
    static stack<T, ContainerT>
    createDeviceObject(const index_t& size);

    /**
     * \brief Destroys the given object of this class on the GPU (device)
     * \param[in] device_object The object allocated on the GPU (device)
     */
    static void
    destroyDeviceObject(stack<T, ContainerT>& device_object);

    /**
     * \brief Empty constructor
     */
    stack() = default;

    /**
     * \brief Add the element to the stack
     * \param[in] element An element
     * \return True if not full, false otherwise
     */
    STDGPU_DEVICE_ONLY bool
    push(const T& element);

    /**
     * \brief Removes and returns the current element from stack
     * \return The currently popped element and true if not empty, an empty element T() and false otherwise
     */
    STDGPU_DEVICE_ONLY pair<T, bool>
    pop();

    /**
     * \brief Checks if the object is empty
     * \return True if the object is empty, false otherwise
     */
    [[nodiscard]] STDGPU_HOST_DEVICE bool
    empty() const;

    /**
     * \brief Checks if the object is full
     * \return True if the object is full, false otherwise
     */
    STDGPU_HOST_DEVICE bool
    full() const;

    /**
     * \brief Returns the current size
     * \return The size
     */
    STDGPU_HOST_DEVICE index_t
    size() const;

    /**
     * \brief Returns the capacity
     * \return The capacity
     */
    STDGPU_HOST_DEVICE index_t
    capacity() const;

    /**
     * \brief Checks if the object is in a valid state
     * \return True if the state is valid, false otherwise
     */
    bool
    valid() const;

private:
    ContainerT _c = {};
};

} // namespace stdgpu

/**
 * @}
 */

#include <stdgpu/impl/stack_detail.cuh>

#endif // STDGPU_STACK_H
