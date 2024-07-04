#pragma once

#include "barretenberg/relations/generic_permutation/generic_permutation_relation.hpp"

#include <cstddef>
#include <tuple>

namespace bb {

class perm_main_mem_ind_addr_d_permutation_settings {
  public:
    // This constant defines how many columns are bundled together to form each set.
    constexpr static size_t COLUMNS_PER_SET = 4;

    template <typename AllEntities> static inline auto inverse_polynomial_is_computed_at_row(const AllEntities& in)
    {
        return (in.main_sel_resolve_ind_addr_d == 1 || in.mem_sel_resolve_ind_addr_d == 1);
    }

    template <typename AllEntities> static inline auto get_const_entities(const AllEntities& in)
    {
        return std::forward_as_tuple(in.perm_main_mem_ind_addr_d,
                                     in.main_sel_resolve_ind_addr_d,
                                     in.main_sel_resolve_ind_addr_d,
                                     in.mem_sel_resolve_ind_addr_d,
                                     in.main_clk,
                                     in.main_space_id,
                                     in.main_ind_addr_d,
                                     in.main_mem_addr_d,
                                     in.mem_clk,
                                     in.mem_space_id,
                                     in.mem_addr,
                                     in.mem_val);
    }

    template <typename AllEntities> static inline auto get_nonconst_entities(AllEntities& in)
    {
        return std::forward_as_tuple(in.perm_main_mem_ind_addr_d,
                                     in.main_sel_resolve_ind_addr_d,
                                     in.main_sel_resolve_ind_addr_d,
                                     in.mem_sel_resolve_ind_addr_d,
                                     in.main_clk,
                                     in.main_space_id,
                                     in.main_ind_addr_d,
                                     in.main_mem_addr_d,
                                     in.mem_clk,
                                     in.mem_space_id,
                                     in.mem_addr,
                                     in.mem_val);
    }
};

template <typename FF_>
using perm_main_mem_ind_addr_d_relation =
    GenericPermutationRelation<perm_main_mem_ind_addr_d_permutation_settings, FF_>;
template <typename FF_>
using perm_main_mem_ind_addr_d = GenericPermutation<perm_main_mem_ind_addr_d_permutation_settings, FF_>;

} // namespace bb